import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../stores/scene_eval_store.dart';
import 'camera_preview_box.dart';

class CaptureButton extends StatelessWidget {
  final bool starting;
  final SceneEvalStore store;
  final VoidCallback onPressed;

  const CaptureButton({
    required this.starting,
    required this.store,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return ValueListenableBuilder<bool>(
          valueListenable: CameraPreviewBox.isReady,
          builder: (_, ready, _) {
            final disabled =
                starting ||
                store.isCapturing ||
                store.isUploading ||
                store.isDiagnosing ||
                !ready;

            return Center(
              child: GestureDetector(
                onTap: disabled ? null : onPressed,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(
                        disabled ? 0.3 : 1.0,
                      ),
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: disabled
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(1.0),
                      ),
                      child: (store.isCapturing ||
                              store.isUploading ||
                              store.isDiagnosing)
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
