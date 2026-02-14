// camera_preview_box.dart: Componente para exibir a pré-visualização da câmera
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraPreviewBox extends StatefulWidget {
  const CameraPreviewBox({super.key});

  static CameraController? controller;

  @override
  State<CameraPreviewBox> createState() => _CameraPreviewBoxState();
}

class _CameraPreviewBoxState extends State<CameraPreviewBox> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    CameraPreviewBox.controller = _controller;

    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    await _controller!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Inverte o aspect ratio para portrait
          final aspectRatio = 1 / _controller!.value.aspectRatio;
          
          return Center(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CameraPreview(_controller!),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
