import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdleState extends StatelessWidget {
  const IdleState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Move slowly and keep the phone steady.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w400,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Capture textures and avoid reflections.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white.withOpacity(0.80),
            fontWeight: FontWeight.w300,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
