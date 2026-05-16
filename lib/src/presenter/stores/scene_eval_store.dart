import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:mobx/mobx.dart';
import '../../external/adapters/scene_diagnosis_adapter.dart';
import '../../external/config/backend_session.dart';
import '../../external/datasources/scene_datasource.dart';
import '../../external/datasources/scene_upload_datasource.dart';
import '../../external/services/camera_service.dart';
import '../../models/scene_diagnosis.dart';

part 'scene_eval_store.g.dart';

// Rebuild generated store file with:
// dart run build_runner build --delete-conflicting-outputs

/// MobX store responsible for the scene evaluation workflow.
///
/// A [SceneEvalStore] coordinates frame capture, upload, backend diagnosis,
/// polling, result adaptation, and UI state updates during the complete
/// evaluation flow.
class SceneEvalStore = _SceneEvalStore with _$SceneEvalStore;

/// Store implementation for scene capture and diagnosis state management.
abstract class _SceneEvalStore with Store {
  /// Datasource used to start, poll, and retrieve scene diagnosis results.
  final SceneDatasource datasource;

  /// Datasource used to upload captured frames to the backend.
  final SceneUploadDatasource uploadDatasource;

  /// Active backend session containing endpoint and timeout configuration.
  final BackendSession backendSession;

  /// Creates the scene evaluation store with injected dependencies.
  ///
  /// Dependency injection keeps the store easier to test and allows different
  /// datasource implementations, such as real HTTP datasources or fake ones.
  _SceneEvalStore(this.datasource, this.uploadDatasource, this.backendSession);

  /// Timer used to update capture progress and remaining time.
  Timer? _timer;

  /// Whether the camera capture step is currently active.
  @observable
  bool isCapturing = false;

  /// Whether captured frames are currently being uploaded.
  @observable
  bool isUploading = false;

  /// Whether backend diagnosis is currently running.
  @observable
  bool isDiagnosing = false;

  /// Number of frames captured in the current evaluation.
  @observable
  int capturedFrames = 0;

  /// Capture progress from `0.0` to `1.0`.
  @observable
  double progress = 0.0;

  /// Remaining capture time, in seconds.
  @observable
  int secondsRemaining = 10;

  /// Frames captured during the latest evaluation.
  @observable
  List<Uint8List> lastCapturedFrames = [];

  /// Diagnosis result from the latest completed evaluation.
  @observable
  SceneDiagnosis? lastResult;

  /// Raw upload response returned by the backend.
  ///
  /// This usually contains metadata such as the generated `batch_id`.
  @observable
  Map<String, dynamic>? lastUploadResponse;

  /// Upload error message, when the upload step fails.
  @observable
  String? uploadError;

  /// Diagnosis error message, when the diagnosis step fails.
  @observable
  String? diagnosisError;

  /// Batch identifier returned by the backend after upload.
  ///
  /// This identifier is used to start diagnosis and poll its status.
  @observable
  String? batchId;

  /// Current diagnosis workflow status.
  ///
  /// Expected values include `idle`, `uploading`, `uploaded`, `processing`,
  /// `completed`, `failed`, or backend-defined status values.
  @observable
  String diagnosisStatus = 'idle';

  /// Starts the countdown used during the capture window.
  ///
  /// The timer periodically updates [progress] and [secondsRemaining] so the
  /// UI can reflect capture progress in real time.
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

  /// Starts the full scene capture and evaluation workflow.
  ///
  /// The method captures frames from the provided camera [controller], stores
  /// them for later inspection, uploads them to the backend, and starts the
  /// diagnosis workflow.
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

    const duration = Duration(seconds: 10);
    _startCountdown(duration);

    try {
      final cameraService = CameraService(controller);

      // Capture frames and update the UI after each successful capture.
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

      // Store the final capture state before upload starts.
      runInAction(() {
        capturedFrames = frames.length;
        progress = 1.0;
        secondsRemaining = 0;
        lastCapturedFrames = frames;
        isCapturing = false;
      });

      if (frames.isEmpty) {
        throw Exception('No frames were captured.');
      }

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

  /// Uploads captured [frames] and runs the backend diagnosis workflow.
  ///
  /// This method uploads the frame batch, extracts the backend `batch_id`,
  /// starts diagnosis, polls the diagnosis status until completion, retrieves
  /// the final result, and adapts it into a [SceneDiagnosis].
  @action
  Future<void> _uploadAndDiagnose(List<Uint8List> frames) async {
    // Upload captured frames.
    isUploading = true;
    diagnosisStatus = 'uploading';

    try {
      final uploadResponse = await uploadDatasource.uploadFrames(frames);
      final returnedBatchId = uploadResponse['batch_id']?.toString();

      if (returnedBatchId == null || returnedBatchId.isEmpty) {
        throw Exception('Invalid response: batch_id not found.');
      }

      runInAction(() {
        batchId = returnedBatchId;
        lastUploadResponse = uploadResponse;
        diagnosisStatus = 'uploaded';
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

    // Start backend diagnosis.
    isDiagnosing = true;

    try {
      // Keep the upload-complete state visible before switching to processing.
      await Future.delayed(const Duration(milliseconds: 1000));

      runInAction(() {
        diagnosisStatus = 'processing';
      });

      await datasource.startDiagnosis(batchId!);

      // Poll the backend until diagnosis is completed or failed.
      while (true) {
        await Future.delayed(
          Duration(seconds: backendSession.pollingIntervalSeconds),
        );

        final statusResponse = await datasource.getDiagnosisStatus(batchId!);
        final status = statusResponse['status']?.toString() ?? 'unknown';

        runInAction(() {
          diagnosisStatus = status;
        });

        if (status == 'completed') {
          break;
        }

        if (status == 'failed') {
          throw Exception(
            statusResponse['error']?.toString() ?? 'Diagnosis failed.',
          );
        }
      }

      final resultResponse = await datasource.getDiagnosisResult(batchId!);

      runInAction(() {
        lastResult = SceneDiagnosisAdapter.fromBackend(resultResponse);
        diagnosisStatus = 'completed';
      });

      // Keep the completion message visible briefly before navigation.
      await Future.delayed(const Duration(milliseconds: 600));
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

  /// Cancels active timers when the store is no longer needed.
  void dispose() {
    _timer?.cancel();
  }
}
