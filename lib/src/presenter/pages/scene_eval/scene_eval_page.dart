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

/// Displays the scene capture and evaluation workflow.
///
/// A [SceneEvalPage] controls the user-facing evaluation flow: camera preview,
/// frame capture, upload, backend diagnosis, and navigation to the result page
/// when the diagnosis is completed.
class SceneEvalPage extends StatefulWidget {
  /// Creates the scene evaluation page.
  const SceneEvalPage({super.key});

  @override
  State<SceneEvalPage> createState() => _SceneEvalPageState();
}

/// State responsible for coordinating capture, processing states, and result navigation.
class _SceneEvalPageState extends State<SceneEvalPage> {
  /// Whether the start action is currently being triggered.
  bool _starting = false;

  /// Starts the capture and diagnosis workflow.
  ///
  /// The method checks whether the camera is ready, triggers the store capture
  /// pipeline, and navigates to [ResultPage] when a diagnosis result is
  /// available.
  Future<void> _onStartPressed(SceneEvalStore store) async {
    final controller = CameraPreviewBox.controller;

    if (controller == null || !controller.value.isInitialized) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera not ready')));
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (!mounted) return;

      final message = store.diagnosisError ?? store.uploadError ?? e.toString();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  /// Builds the central UI state according to the current evaluation phase.
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
      return const UploadingState(key: ValueKey('uploading'));
    }

    if (store.isDiagnosing) {
      return ProcessingState(
        key: const ValueKey('processing'),
        status: store.diagnosisStatus,
      );
    }

    return const IdleState(key: ValueKey('idle'));
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<SceneEvalStore>();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,

      // Transparent app bar keeps the camera preview as the main visual layer.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Observer(
        builder: (_) {
          final store = context.read<SceneEvalStore>();

          final isProcessingPhase = store.isUploading || store.isDiagnosing;

          if (isProcessingPhase) {
            // Focus mode hides the camera while upload or diagnosis is running.
            return Container(
              color: Colors.black,
              child: Center(
                child: store.isUploading
                    ? const UploadingState()
                    : ProcessingState(status: store.diagnosisStatus),
              ),
            );
          }

          // Normal mode keeps the camera preview visible during idle/capture.
          return Stack(
            children: [
              // Full-screen camera preview.
              const Positioned.fill(child: CameraPreviewBox()),

              // Dark overlay to improve foreground readability.
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),

              // Central state card with animated transitions.
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

              // Bottom capture button used to start the evaluation flow.
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
