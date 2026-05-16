import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// Service responsible for capturing camera frames as image bytes.
///
/// A [CameraService] wraps a [CameraController] and provides a controlled
/// capture routine that collects a fixed number of frames over a given time
/// window. The captured frames are returned as [Uint8List] values so they can
/// be uploaded to the backend diagnosis pipeline.
class CameraService {
  /// Camera controller used to capture image frames.
  final CameraController controller;

  /// Creates a camera service using the provided [controller].
  CameraService(this.controller);

  /// Captures image frames during a defined [duration].
  ///
  /// Frames are captured at the specified [interval] until either [maxFrames]
  /// is reached or the total capture duration expires. The optional
  /// [onFrameCaptured] callback is called after each successful capture and
  /// can be used by the UI to update progress indicators.
  ///
  /// Throws an [Exception] if the camera controller is not initialized.
  Future<List<Uint8List>> captureFor({
    required Duration duration,
    required Duration interval,
    int maxFrames = 10,
    void Function(int count)? onFrameCaptured,
  }) async {
    final frames = <Uint8List>[];
    final startTime = DateTime.now();

    for (int i = 0; i < maxFrames; i++) {
      final targetTime = startTime.add(interval * i);
      final now = DateTime.now();

      if (now.difference(startTime) >= duration) {
        break;
      }

      if (now.isBefore(targetTime)) {
        await Future.delayed(targetTime.difference(now));
      }

      if (!controller.value.isInitialized) {
        throw Exception('Camera not initialized.');
      }

      if (controller.value.isTakingPicture) {
        await Future.delayed(const Duration(milliseconds: 50));
        i--;
        continue;
      }

      try {
        final file = await controller.takePicture();
        final bytes = await file.readAsBytes();

        frames.add(bytes);
        onFrameCaptured?.call(frames.length);

        debugPrint('Captured frame ${frames.length}/$maxFrames');
      } catch (e) {
        debugPrint('Frame capture error: $e');
        break;
      }
    }

    debugPrint('Finished capturing frames: ${frames.length} frames captured');

    return frames;
  }
}
