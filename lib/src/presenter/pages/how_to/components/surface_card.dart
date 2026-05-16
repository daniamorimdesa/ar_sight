import 'package:flutter/material.dart';

/// Displays a reusable elevated surface container.
///
/// A [SurfaceCard] wraps content inside a white card with rounded corners,
/// border, padding, and a subtle shadow. It is used to group related guidance
/// items in the instructions page.
class SurfaceCard extends StatelessWidget {
  /// Content displayed inside the card.
  final Widget child;

  /// Creates a styled surface card.
  const SurfaceCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
