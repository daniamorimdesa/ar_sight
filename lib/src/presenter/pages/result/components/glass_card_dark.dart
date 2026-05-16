import 'package:flutter/material.dart';

/// Displays a reusable dark glass-style card container.
///
/// A [GlassCardDark] wraps content inside a translucent dark surface with
/// rounded corners and a subtle border. It is used to group visual sections
/// in the result page.
class GlassCardDark extends StatelessWidget {
  /// Content displayed inside the card.
  final Widget child;

  /// Creates a dark glass-style card.
  const GlassCardDark({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: child,
    );
  }
}
