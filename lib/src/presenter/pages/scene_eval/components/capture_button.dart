import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../stores/scene_eval_store.dart';
import 'camera_preview_box.dart';

/// Displays the circular capture button used to start scene evaluation.
///
/// A [CaptureButton] observes both the camera readiness state and the
/// [SceneEvalStore] workflow state to enable or disable user interaction.
class CaptureButton extends StatelessWidget {
  /// Whether the start action is currently being triggered.
  final bool starting;

  /// Store containing the current scene evaluation state.
  final SceneEvalStore store;

  /// Callback executed when the button is tapped while enabled.
  final VoidCallback onPressed;

  /// Creates a capture button for the scene evaluation page.
  const CaptureButton({
    super.key,
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
            // Disable capture while the camera is not ready or a workflow step is active.
            final disabled =
                starting ||
                store.isCapturing ||
                store.isUploading ||
                store.isDiagnosing ||
                !ready;

            return Center(
              child: GestureDetector(
                onTap: disabled ? null : onPressed,

                // Outer capture ring.
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(disabled ? 0.3 : 1.0),
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),

                    // Inner capture button surface.
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: disabled
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(1.0),
                      ),

                      // Show a progress indicator while capture, upload, or diagnosis is active.
                      child:
                          (store.isCapturing ||
                              store.isUploading ||
                              store.isDiagnosing)
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
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
