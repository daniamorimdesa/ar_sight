// scene_eval_page.dart: Tela de captura e avaliação da cena
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../stores/scene_eval_store.dart';
import '../result/result_page.dart';
import 'components/camera_preview_box.dart';
import 'components/capture_button.dart';
import 'components/glass_box.dart';
import 'components/states/capturing_state.dart';
import 'components/states/idle_state.dart';
import 'components/states/processing_state.dart';
import 'components/states/uploading_state.dart';

class SceneEvalPage extends StatefulWidget {
  const SceneEvalPage({super.key});

  @override
  State<SceneEvalPage> createState() => _SceneEvalPageState();
}

class _SceneEvalPageState extends State<SceneEvalPage> {
  bool _starting = false;

  Future<void> _onStartPressed(SceneEvalStore store) async {
    final controller = CameraPreviewBox.controller;

    if (controller == null || !controller.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not ready')),
      );
      return;
    }

    setState(() => _starting = true);

    try {
      await store.startCapture(controller);

      if (!mounted) return;

      if (store.lastResult != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultPage(diagnosis: store.lastResult!),
          ),
        );
      } else {
        final message =
            store.diagnosisError ??
            store.uploadError ??
            'No diagnosis returned';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (!mounted) return;

      final message =
          store.diagnosisError ??
          store.uploadError ??
          e.toString();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Widget _buildCenterState(SceneEvalStore store) {
    if (store.isCapturing) {
      return CapturingState(
        key: const ValueKey('capturing'),
        secondsRemaining: store.secondsRemaining,
        progress: store.progress,
        capturedFrames: store.capturedFrames,
      );
    }

    if (store.isUploading) {
      return const UploadingState(
        key: ValueKey('uploading'),
      );
    }

    if (store.isDiagnosing) {
      return ProcessingState(
        key: const ValueKey('processing'),
        status: store.diagnosisStatus,
      );
    }

    return const IdleState(
      key: ValueKey('idle'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<SceneEvalStore>();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Observer(
        builder: (_) {
          final store = context.read<SceneEvalStore>();

          final isProcessingPhase =
              store.isUploading || store.isDiagnosing;

          if (isProcessingPhase) {
            // 🌑 MODO FOCO (SEM CÂMERA)
            return Container(
              color: Colors.black,
              child: Center(
                child: store.isUploading
                    ? const UploadingState()
                    : ProcessingState(
                        status: store.diagnosisStatus,
                      ),
              ),
            );
          }

          // 📸 MODO NORMAL (COM CÂMERA)
          return Stack(
            children: [
              const Positioned.fill(child: CameraPreviewBox()),

              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GlassBox(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _buildCenterState(store),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CaptureButton(
                  starting: _starting,
                  store: store,
                  onPressed: () => _onStartPressed(store),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
