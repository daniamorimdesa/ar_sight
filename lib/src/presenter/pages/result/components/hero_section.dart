import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'status_icon.dart';

class HeroSection extends StatelessWidget {
  final bool isPass;
  final Color accent;

  const HeroSection({
    super.key,
    required this.isPass,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final title = isPass ? 'SCENE READY' : 'SCENE NEEDS ADJUSTMENTS';

    return Column(
      children: [
        StatusIcon(accent: accent, isPass: isPass),
        const SizedBox(height: 14),
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
