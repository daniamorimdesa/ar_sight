// camera_preview_box.dart: Componente para exibir a pré-visualização da câmera
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraPreviewBox extends StatefulWidget {
  const CameraPreviewBox({super.key});

  static CameraController? controller;
  static final ValueNotifier<bool> isReady = ValueNotifier<bool>(false);


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

    CameraPreviewBox.isReady.value = true;

    if (!mounted) return;
    setState(() {});
  }


   @override
  void dispose() {
    _controller?.dispose();
    if (CameraPreviewBox.controller == _controller) {
      CameraPreviewBox.controller = null;
    }
    CameraPreviewBox.isReady.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _initializeControllerFuture == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
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
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
