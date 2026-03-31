import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CapturingState extends StatelessWidget {
  final int secondsRemaining;
  final double progress;
  final int capturedFrames;

  const CapturingState({
    super.key,
    required this.secondsRemaining,
    required this.progress,
    required this.capturedFrames,
  });

  @override
  Widget build(BuildContext context) {
    const glowColor = Color(0xFF00D4FF);

    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Scanning your environment',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time: ${secondsRemaining}s',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              'Frames: $capturedFrames/10',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.82),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: glowColor.withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(glowColor),
            ),
          ),
        ),
      ],
    );
  }
}
