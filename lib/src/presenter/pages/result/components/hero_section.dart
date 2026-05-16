import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'status_icon.dart';

/// Displays the main visual status of the scene diagnosis.
///
/// A [HeroSection] appears at the top of the result page and presents the
/// overall scene readiness status using a [StatusIcon] and a concise title.
class HeroSection extends StatelessWidget {
  /// Whether the evaluated scene passed the diagnosis criteria.
  final bool isPass;

  /// Accent color associated with the diagnosis status.
  final Color accent;

  /// Creates the main result status section.
  const HeroSection({super.key, required this.isPass, required this.accent});

  @override
  Widget build(BuildContext context) {
    final title = isPass ? 'SCENE READY' : 'SCENE NEEDS ADJUSTMENTS';

    return Column(
      children: [
        // Main status icon.
        StatusIcon(accent: accent, isPass: isPass),

        const SizedBox(height: 14),

        // Main diagnosis status title.
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.95),
          ),
        ),
      ],
    );
  }
}
