import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays the live camera preview used during scene evaluation.
///
/// A [CameraPreviewBox] initializes the device camera, locks the capture
/// orientation to portrait mode, and exposes the active [CameraController] so
/// the evaluation flow can capture frames from it.
class CameraPreviewBox extends StatefulWidget {
  /// Creates a camera preview component.
  const CameraPreviewBox({super.key});

  /// Active camera controller used by the scene evaluation flow.
  static CameraController? controller;

  /// Notifies whether the camera preview is initialized and ready.
  static final ValueNotifier<bool> isReady = ValueNotifier<bool>(false);

  @override
  State<CameraPreviewBox> createState() => _CameraPreviewBoxState();
}

/// State responsible for initializing, displaying, and disposing the camera.
class _CameraPreviewBoxState extends State<CameraPreviewBox> {
  /// Local camera controller owned by this preview widget.
  CameraController? _controller;

  /// Future used to track camera initialization.
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  /// Initializes the first available camera for portrait image capture.
  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    // Configure the camera for high-resolution JPEG frame capture.
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    CameraPreviewBox.controller = _controller;

    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    // Keep captured frames aligned with the portrait UI orientation.
    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    CameraPreviewBox.isReady.value = true;

    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();

    // Clear the shared controller reference only if it belongs to this widget.
    if (CameraPreviewBox.controller == _controller) {
      CameraPreviewBox.controller = null;
    }

    CameraPreviewBox.isReady.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return _buildLoadingState();
    }

    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Invert the camera aspect ratio to fit the portrait layout.
          final aspectRatio = 1 / _controller!.value.aspectRatio;

          return Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CameraPreview(_controller!),
            ),
          );
        }

        return _buildLoadingState();
      },
    );
  }

  /// Builds the loading state shown while the camera is initializing.
  Widget _buildLoadingState() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
