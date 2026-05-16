import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a single instruction tip with an icon, title, and description.
///
/// A [TipRow] is used in the instructions page to present scan guidance and
/// environment recommendations in a compact, readable layout.
class TipRow extends StatelessWidget {
  /// Icon used to visually represent the tip.
  final IconData icon;

  /// Main title of the instruction tip.
  final String title;

  /// Descriptive text explaining the instruction.
  final String text;

  /// Creates an instruction row with an [icon], [title], and descriptive [text].
  const TipRow({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leading visual indicator for the instruction.
        Icon(icon, color: const Color(0xFF3B82F6), size: 26),

        const SizedBox(width: 10),

        // Textual content of the instruction.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tip title.
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              // Tip description.
              Text(
                text,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
