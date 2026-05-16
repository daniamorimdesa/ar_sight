import 'package:flutter/material.dart';

/// Displays a visual separator between instruction rows.
///
/// A [TipDivider] is used inside guidance cards to separate individual tips
/// while keeping consistent spacing and color.
class TipDivider extends StatelessWidget {
  /// Creates a divider for instruction sections.
  const TipDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Color(0xFFE5E7EB), height: 1),
    );
  }
}
