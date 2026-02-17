import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import '../../external/adapters/scene_diagnosis_adapter.dart';
import '../../external/datasources/fake_scene_datasource.dart';
import '../../external/datasources/scene_datasource.dart';
import '../../external/services/camera_service.dart';
import '../../models/scene_diagnosis.dart';

part 'scene_eval_store.g.dart';

class SceneEvalStore = _SceneEvalStore with _$SceneEvalStore;

abstract class _SceneEvalStore with Store {
  Timer? _timer; // Timer para contagem regressiva e atualização de progresso
  final dio =
      Dio(); // dio é usado apenas para o SceneDatasourceImpl, mas mantemos aqui para facilitar a troca futura
  final SceneDatasource datasource =
      FakeSceneDatasource(); // Usamos o fake datasource por enquanto

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
}
