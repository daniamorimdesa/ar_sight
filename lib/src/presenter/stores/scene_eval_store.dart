// scene_eval_store.dart: responsável por gerenciar o estado da captura e avaliação da cena, incluindo a contagem regressiva, o progresso da captura, os frames capturados e o resultado da avaliação.
import 'dart:async';
import 'dart:typed_data';
import 'package:ar_sight/src/external/datasources/scene_upload_datasource.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../../external/adapters/scene_diagnosis_adapter.dart';
import '../../external/datasources/fake_scene_datasource.dart';
import '../../external/datasources/scene_datasource.dart';
import '../../external/services/camera_service.dart';
import '../../models/scene_diagnosis.dart';

part 'scene_eval_store.g.dart';

// comando para rebuildar store:  dart run build_runner build --delete-conflicting-outputs

class SceneEvalStore = _SceneEvalStore with _$SceneEvalStore;

abstract class _SceneEvalStore with Store {
  Timer? _timer; // Timer para contagem regressiva e atualização de progresso

  // Instância do Dio para fazer requisições HTTP
  final dio = Dio();

  // Datasource fake para avaliação da cena, apenas para testes de UI sem depender do backend
  final SceneDatasource datasource = FakeSceneDatasource();

  // Datasource para upload dos frames, usado para testar a comunicação com o backend
  late final SceneUploadDatasource uploadDatasource = SceneUploadDatasourceImpl(
    dio,
  );

  // flag para indicar se a captura está em andamento
  @observable
  bool isCapturing = false;

  // número de frames capturados até o momento
  @observable
  int capturedFrames = 0;

  // progresso da captura (0.0 a 1.0)
  @observable
  double progress = 0.0;

  // segundos restantes para o final da captura
  @observable
  int secondsRemaining = 10;

  // frames capturados na última avaliação
  @observable
  List<Uint8List> lastCapturedFrames = [];

  // resultado da última avaliação
  @observable
  SceneDiagnosis? lastResult;

  // flag para indicar se o upload dos frames está em andamento
  @observable
  bool isUploading = false;

  // mensagem de erro do upload, caso ocorra
  @observable
  String? uploadError;

  // resposta do upload, contendo informações como session_id, caso o upload seja bem-sucedido
  @observable
  Map<String, dynamic>? lastUploadResponse;

  //--------------------------------------------------------------------------------------------------------------------
  // método para iniciar a captura e avaliação da cena
  void _startCountdown(Duration duration) {
    // Inicia o timer para atualizar o progresso e os segundos restantes
    final start = DateTime.now(); // Marca o início da captura
    final end = start.add(
      duration,
    ); // Calcula o momento em que a captura deve terminar

    // Cancela qualquer timer anterior, caso exista
    _timer?.cancel();

    // Inicia um timer periódico que atualiza a cada 100ms
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final now = DateTime.now();

      if (now.isAfter(end)) {
        // Se o tempo acabou, para o timer e garante que o progresso esteja completo
        _timer?.cancel();
        return;
      }

      final elapsed = now.difference(
        start,
      ); // Calcula o tempo decorrido desde o início da captura
      final remaining = end.difference(
        now,
      ); // Calcula o tempo restante até o final da captura

      // Atualiza o progresso e os segundos restantes na interface
      runInAction(() {
        progress = elapsed.inMilliseconds / duration.inMilliseconds;
        secondsRemaining =
            remaining.inSeconds +
            1; // +1 para mostrar o segundo atual até o final
      });
    });
  }
  //--------------------------------------------------------------------------------------------------------------------

  // método para iniciar a captura e avaliação da cena
  @action
  Future<void> startCapture(CameraController controller) async {
    isCapturing = true;
    capturedFrames = 0;

    const duration = Duration(seconds: 10);

    _startCountdown(duration);

    try {
      final cameraService = CameraService(controller);

      final frames = await cameraService.captureFor(
        duration: duration,
        interval: const Duration(seconds: 1),
        maxFrames: 10,
        onFrameCaptured: (count) {
          // Atualiza o número de frames capturados a cada nova captura
          runInAction(() {
            capturedFrames = count;
          });
        },
      );
      // Quando a captura é concluída, atualiza o progresso para 100% e os segundos restantes para 0
      runInAction(() {
        capturedFrames = frames.length;
        progress = 1.0;
        secondsRemaining = 0;
        lastCapturedFrames = frames;
      });

      // chama o upload das imagens para testar a comunicação com o backend
      await uploadLastFrames();

      // Envia os frames capturados para avaliação e aguarda a resposta
      final response = await datasource.evaluateScene(frames);

      // Quando a resposta é recebida, atualiza o resultado da avaliação
      runInAction(() {
        lastResult = SceneDiagnosisAdapter.fromMap(response.first);
      });
    } finally {
      // Garante que o timer seja cancelado quando a captura terminar
      _timer?.cancel();
      // Reseta a flag de captura para permitir novas capturas
      isCapturing = false;
    }
  }

  //--------------------------------------------------------------------------------------------------------------------

  // método para limpar os dados da última avaliação
  void dispose() {
    _timer?.cancel();
  }

  //--------------------------------------------------------------------------------------------------------------------

  // método para enviar os frames capturados para upload e receber as informações de upload
  @action
  Future<void> uploadLastFrames({String? sessionId}) async {
    uploadError = null;
    lastUploadResponse = null;

    if (lastCapturedFrames.isEmpty) {
      uploadError = 'Não há frames capturados para enviar.';
      return;
    }

    isUploading = true;
    try {
      // Se um sessionId foi fornecido, use-o; caso contrário, gere um novo sessionId baseado no timestamp atual
      final sid = sessionId ?? DateTime.now().millisecondsSinceEpoch.toString();

      // confirma que vai tentar enviar as imagens
      debugPrint('Upload: enviando ${lastCapturedFrames.length} frames... session_id=$sid');

      // Envia os frames para upload e aguarda a resposta do backend
      final response = await uploadDatasource.uploadFrames(
        lastCapturedFrames,
        sessionId: sid,
      );

      // confirma que recebeu resposta do backend
       debugPrint('Upload: resposta = ${response.toString()}');
       
      // Quando a resposta é recebida, atualiza as informações de upload na interface
      runInAction(() {
        lastUploadResponse = response;
      });
    } catch (e) {
      // Em caso de erro, registra a mensagem de erro e imprime no console para depuração
      debugPrint('Upload: erro = $e');
      runInAction(() {
        uploadError = e.toString();
      });
    } finally {
      runInAction(() {
        isUploading = false;
      });
    }
  }
}
