import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a compact statistic card with an icon, value, and title.
///
/// A [StatCard] is used to present performance metrics in the result page,
/// such as PDI processing time and SLM inference time.
class StatCard extends StatelessWidget {
  /// Metric title displayed below the value.
  final String title;

  /// Formatted metric value displayed prominently in the card.
  final String value;

  /// Icon representing the metric category.
  final IconData icon;

  /// Accent color used as the default icon color.
  final Color accent;

  /// Optional custom color for the metric icon.
  ///
  /// When omitted, [accent] is used.
  final Color? iconColor;

  /// Creates a statistic card with a [title], [value], and [icon].
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metric category icon.
          Icon(icon, color: iconColor ?? accent, size: 32),

          const SizedBox(height: 18),

          // Main metric value.
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.92),
            ),
          ),

          const SizedBox(height: 6),

          // Metric title.
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}
