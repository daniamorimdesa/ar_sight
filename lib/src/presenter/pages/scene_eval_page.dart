import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'components/camera_preview_box.dart';
import '../stores/scene_eval_store.dart';
import 'frames_preview_page.dart';
import 'result_page.dart';

class SceneEvalPage extends StatefulWidget {
  const SceneEvalPage({super.key});

  @override
  State<SceneEvalPage> createState() => _SceneEvalPageState();
}

class _SceneEvalPageState extends State<SceneEvalPage> {
  final SceneEvalStore store = SceneEvalStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  Future<void> _onStartPressed() async {
    final controller = CameraPreviewBox.controller;

    if (controller == null || !controller.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not ready')),
      );
      return;
    }

    await store.startCapture(controller);

    if (store.lastCapturedFrames.isNotEmpty && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FramesPreviewPage(
            frames: store.lastCapturedFrames,
          ),
        ),
      );
    }

    if (store.lastResult != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultPage(diagnosis: store.lastResult),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan (10s)')),
      body: Stack(
        children: [
          const Positioned.fill(child: CameraPreviewBox()),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Observer(
              builder: (_) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (store.isCapturing) ...[
                          Text(
                            'Time remaining: ${store.secondsRemaining} s',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: store.progress),
                        ],

                        const SizedBox(height: 12),

                        FilledButton(
                          onPressed: store.isCapturing ? null : _onStartPressed,
                          child: Text(
                            store.isCapturing ? 'Scanning...' : 'Begin 10s scan',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
