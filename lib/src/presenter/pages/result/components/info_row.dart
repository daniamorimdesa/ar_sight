import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a labeled information row with an optional leading icon.
///
/// An [InfoRow] is used to present compact metadata or metric values in the
/// result page, such as model name, device, environment, or performance data.
class InfoRow extends StatelessWidget {
  /// Label displayed before the value.
  final String label;

  /// Value displayed after the label.
  final String value;

  /// Accent color used to highlight the value and default icon color.
  final Color accent;

  /// Optional leading icon displayed before the label.
  final IconData? icon;

  /// Optional custom color for the leading [icon].
  ///
  /// When omitted, [accent] is used.
  final Color? iconColor;

  /// Optional custom color for the label text.
  ///
  /// When omitted, a semi-transparent white color is used.
  final Color? labelColor;

  /// Creates an information row with a [label], [value], and [accent] color.
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional leading icon.
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? accent, size: 20),
          const SizedBox(width: 10),
        ],

        // Information label.
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: labelColor ?? Colors.white.withOpacity(0.75),
          ),
        ),

        // Highlighted information value.
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: accent.withOpacity(0.95),
            ),
          ),
        ),
      ],
    );
  }
}
