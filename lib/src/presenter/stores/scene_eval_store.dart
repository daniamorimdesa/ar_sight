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
  Timer? _timer;
  final dio = Dio();
  final SceneDatasource datasource = FakeSceneDatasource();
  late SceneDiagnosis lastResult;

  @observable
  bool isCapturing = false;

  @observable
  int capturedFrames = 0;

  @observable
  double progress = 0.0;

  @observable
  int secondsRemaining = 10;

  @observable
  List<Uint8List> lastCapturedFrames = const [];

  void _startCountdown(Duration duration) {
    final start = DateTime.now();
    final end = start.add(duration);

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
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
      },
    );
  }

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
          runInAction(() {
            capturedFrames = count;
          });
        },
      );

      capturedFrames = frames.length;
      progress = 1.0;
      secondsRemaining = 0;

      lastCapturedFrames = frames;

      final response = await datasource.evaluateScene(frames);
      lastResult = SceneDiagnosisAdapter.fromMap(response.first);
    } finally {
      _timer?.cancel();
      isCapturing = false;
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
