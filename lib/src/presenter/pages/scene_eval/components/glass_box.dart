import 'package:flutter/material.dart';

/// Displays a translucent container for scene evaluation states.
///
/// A [GlassBox] wraps the central state content shown during the camera
/// evaluation flow, such as idle, capturing, uploading, and processing states.
class GlassBox extends StatelessWidget {
  /// Content displayed inside the glass-style container.
  final Widget child;

  /// Creates a translucent state container.
  const GlassBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.50),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: child,
    );
  }
}
