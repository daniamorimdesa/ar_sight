import 'package:flutter/material.dart';

/// Displays the main circular status icon for the diagnosis result.
///
/// A [StatusIcon] visually represents whether the evaluated scene passed or
/// needs adjustments. The icon and glow color are based on the diagnosis
/// status.
class StatusIcon extends StatelessWidget {
  /// Accent color associated with the diagnosis status.
  final Color accent;

  /// Whether the evaluated scene passed the diagnosis criteria.
  final bool isPass;

  /// Creates a status icon for the result hero section.
  const StatusIcon({super.key, required this.accent, required this.isPass});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withOpacity(0.10),
        border: Border.all(color: accent.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.14),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),

      // Status icon selected according to the diagnosis result.
      child: Icon(
        isPass ? Icons.task_alt_rounded : Icons.tips_and_updates_outlined,
        color: accent,
        size: 28,
      ),
    );
  }
}
