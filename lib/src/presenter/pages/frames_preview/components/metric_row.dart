import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a labeled metric value in a compact row layout.
///
/// A [MetricRow] is used to present frame-level diagnostic metrics, such as
/// illumination label, score, brightness, and uniformity. The [color] parameter
/// highlights the metric value with a consistent visual accent.
class MetricRow extends StatelessWidget {
  /// Metric name displayed on the left side of the row.
  final String label;

  /// Formatted metric value displayed on the right side of the row.
  final String value;

  /// Accent color used to highlight the metric value.
  final Color color;

  /// Creates a metric row with a [label], formatted [value], and accent [color].
  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Metric label.
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.70),
            ),
          ),

          // Highlighted metric value.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              border: Border.all(color: color.withOpacity(0.5), width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
