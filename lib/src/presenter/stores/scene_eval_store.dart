// scene_eval_store.dart: responsável por gerenciar o estado da captura e avaliação da cena, incluindo a contagem regressiva, o progresso da captura, os frames capturados e o resultado da avaliação.

// comando para rebuildar store:  dart run build_runner build --delete-conflicting-outputs

import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:mobx/mobx.dart';

import '../../external/adapters/scene_diagnosis_adapter.dart';
import '../../external/datasources/scene_datasource.dart';
import '../../external/datasources/scene_upload_datasource.dart';
import '../../external/services/camera_service.dart';
import '../../models/scene_diagnosis.dart';

part 'scene_eval_store.g.dart';
//----------------------------------------------------------------------------------------------------------------------------------------------------------------
class SceneEvalStore = _SceneEvalStore with _$SceneEvalStore;

abstract class _SceneEvalStore with Store {

  // Instâncias dos datasources para avaliação da cena e upload dos frames, injetados via construtor para facilitar testes e flexibilidade
  final SceneDatasource datasource;
  final SceneUploadDatasource uploadDatasource;

  _SceneEvalStore(this.datasource, this.uploadDatasource);

  // Timer para contagem regressiva e atualização de progresso durante a captura
  Timer? _timer; 

  //----------------------------------------------------------------------------------------------------------------------------------------------------------------
  // OBSERVABLES
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------
  // flag para indicar se a captura está em andamento
  @observable
  bool isCapturing = false;

  // flag para indicar se o upload dos frames está em andamento
  @observable
  bool isUploading = false; 
  
  // flag para indicar se o diagnóstico está em andamento
  @observable
  bool isDiagnosing = false;

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

  // resposta do upload, contendo informações como batch_id, caso o upload seja bem-sucedido
  @observable
  Map<String, dynamic>? lastUploadResponse;

  // mensagem de erro do upload, caso ocorra
  @observable
  String? uploadError;

  // mensagem de erro do diagnóstico, caso ocorra
  @observable
  String? diagnosisError;

  // batch_id retornado pelo backend após o upload dos frames, usado para acompanhar o status do diagnóstico
  @observable
  String? batchId; 

  // status do diagnóstico: idle, uploading, uploaded, processing, completed, failed
  @observable
  String diagnosisStatus = 'idle'; 

  //----------------------------------------------------------------------------------------------------------------------------------------------------------------
  // AÇÕES
  //----------------------------------------------------------------------------------------------------------------------------------------------------------------
  // método que inicia o timer para atualizar o progresso e os segundos restantes durante a captura
  void _startCountdown(Duration duration) { 
    final start = DateTime.now();
    final end = start.add(duration);

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final now = DateTime.now();

      if (now.isAfter(end)) {
        _timer?.cancel();
        return;
      }

      final elapsed = now.difference(start);
      final remaining = end.difference(now);

      runInAction(() {
        progress = elapsed.inMilliseconds / duration.inMilliseconds;
        secondsRemaining = remaining.inSeconds + 1;
      });
    });
  }

  // método para iniciar a captura e avaliação da cena, capturando frames da câmera, enviando para upload e acompanhamento do diagnóstico
  @action
  Future<void> startCapture(CameraController controller) async { 
    isCapturing = true;
    isUploading = false;
    isDiagnosing = false;
    capturedFrames = 0;
    progress = 0.0;
    secondsRemaining = 10;
    uploadError = null;
    diagnosisError = null;
    diagnosisStatus = 'idle';
    lastResult = null;
    batchId = null;

    // duração total da captura
    const duration = Duration(seconds: 10); 
    _startCountdown(duration);
    
    // captura os frames da câmera usando o CameraService, atualizando o número de frames capturados a cada nova captura
    try {
      final cameraService = CameraService(controller);

      final frames = await cameraService.captureFor(
        duration: duration,
        interval: const Duration(seconds: 1),
        maxFrames: 10,
        onFrameCaptured: (count) {
          runInAction(() {
            capturedFrames = count;
          });
        },
      );

      // runInAction é usado para garantir que as atualizações de estado sejam feitas dentro de uma ação do MobX, 
      // permitindo que a interface reaja corretamente às mudanças de estado
      runInAction(() {
        capturedFrames = frames.length; // Atualiza o número final de frames capturados após a conclusão da captura
        progress = 1.0;                 // Garante que o progresso esteja completo quando a captura terminar
        secondsRemaining = 0;           // Garante que os segundos restantes sejam 0 quando a captura terminar
        lastCapturedFrames = frames;    // Armazena os frames capturados para referência futura e upload
        isCapturing = false;            // Atualiza a flag de captura para false após a conclusão da captura
      });

      // Verifica se algum frame foi capturado antes de tentar enviar para upload, lançando uma exceção se a lista de frames estiver vazia
      if (frames.isEmpty) {
        throw Exception('Nenhum frame foi capturado.');
      }

      // chama o método para enviar os frames para upload e acompanhar o diagnóstico
      await _uploadAndDiagnose(frames); 
    } catch (e) {
      runInAction(() {
        diagnosisError = e.toString();
        diagnosisStatus = 'failed';
      });
    } finally {
      _timer?.cancel();
    }
  }

  // método para enviar os frames capturados para upload e acompanhar o processo de diagnóstico, incluindo o polling do status do diagnóstico até a conclusão
  @action
  Future<void> _uploadAndDiagnose(List<Uint8List> frames) async { 

    // 1. upload dos frames
    isUploading = true;
    diagnosisStatus = 'uploading';

    try {
      // Envia os frames para upload e aguarda a resposta do backend
      final uploadResponse = await uploadDatasource.uploadFrames(frames); 

      // Verifica se a resposta do upload contém um batch_id válido, lançando uma exceção se o batch_id estiver ausente ou vazio
      final returnedBatchId = uploadResponse['batch_id']?.toString(); 

      if (returnedBatchId == null || returnedBatchId.isEmpty) {
        throw Exception('Resposta inválida: batch_id não encontrado.');
      }
      
      // runInAction é usado para garantir que as atualizações de estado sejam feitas dentro de uma ação do MobX, 
      // permitindo que a interface reaja corretamente às mudanças de estado
      runInAction(() { 
        batchId = returnedBatchId;           // Armazena o batch_id retornado pelo backend para acompanhar o diagnóstico
        lastUploadResponse = uploadResponse; // Armazena a resposta do upload para referência futura
        diagnosisStatus = 'uploaded';        // Atualiza o status do diagnóstico para "uploaded" após o upload bem-sucedido
      });
    } catch (e) {
      runInAction(() {
        uploadError = e.toString();
        diagnosisStatus = 'upload_failed';
      });
      rethrow;
    } finally {
      runInAction(() {
        isUploading = false;
      });
    }

    // 2. iniciar o diagnóstico
    isDiagnosing = true;

    try {
      await datasource.startDiagnosis(batchId!); // Inicia o diagnóstico no backend usando o batch_id retornado pelo upload

      runInAction(() {
        diagnosisStatus = 'processing'; // Atualiza o status do diagnóstico para "processing" após iniciar o diagnóstico no backend
      });

      // 3. polling - verifica o status do diagnóstico a cada segundo até que seja "completed" ou "failed", lançando uma exceção em caso de falha
      while (true) {
        await Future.delayed(const Duration(seconds: 1)); // Aguarda 1 segundo antes de verificar o status novamente para evitar sobrecarregar o backend com requisições muito frequentes

        final statusResponse = await datasource.getDiagnosisStatus(batchId!); // Verifica o status do diagnóstico no backend usando o batch_id para acompanhar o progresso do diagnóstico
        final status = statusResponse['status']?.toString() ?? 'unknown';     // Extrai o status do diagnóstico da resposta do backend, usando "unknown" como valor padrão caso o campo "status" esteja ausente

        runInAction(() {
          diagnosisStatus = status; 
        });

        // Verifica o status do diagnóstico e age de acordo: 
        // se for "completed", sai do loop; 
        // se for "failed", lança uma exceção com a mensagem de erro retornada pelo backend ou uma mensagem genérica caso o campo "error" esteja ausente
        if (status == 'completed') {
          break;
        }

        if (status == 'failed') {
          throw Exception(
            statusResponse['error']?.toString() ?? 'Diagnóstico falhou.',
          );
        }
      }

      // 4. resultado final
      final resultResponse = await datasource.getDiagnosisResult(batchId!); // Obtém o resultado final do diagnóstico no backend usando o batch_id para acessar os dados avaliados da cena

      runInAction(() {
        lastResult = SceneDiagnosisAdapter.fromBackend(resultResponse); // Converte a resposta do backend para o modelo SceneDiagnosis usando o adapter e armazena como o resultado da última avaliação
        diagnosisStatus = 'completed';                                  // Atualiza o status do diagnóstico para "completed" após receber o resultado final do backend
      });
    } catch (e) {
      runInAction(() {
        diagnosisError = e.toString();
        diagnosisStatus = 'failed';
      });
      rethrow;
    } finally {
      runInAction(() {
        isDiagnosing = false;
      });
    }
  }
  
  // método para limpar os dados da última avaliação e cancelar o timer, garantindo que o estado seja resetado para permitir novas capturas e avaliações
  void dispose() {
    _timer?.cancel();
  }
}