import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a numbered recommendation row for the dark result layout.
///
/// A [RecommendationRowDark] presents one corrective action with a circular
/// index marker and the recommendation text. It is used inside the result page
/// recommendation section.
class RecommendationRowDark extends StatelessWidget {
  /// One-based recommendation number displayed inside the circular marker.
  final int index;

  /// Recommendation text displayed to the user.
  final String text;

  /// Accent color used for the numbered marker.
  final Color accent;

  /// Creates a numbered recommendation row.
  const RecommendationRowDark({
    super.key,
    required this.index,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular index marker.
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
            child: Text(
              '$index',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Recommendation description.
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.78),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
