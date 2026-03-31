import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrameCardImage extends StatelessWidget {
  final Uint8List frame;
  final int index;

  const FrameCardImage({
    super.key,
    required this.frame,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Frame image
        Positioned.fill(
          child: Image.memory(frame, fit: BoxFit.cover),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Frame label
        Positioned(
          left: 10,
          bottom: 10,
          child: Text(
            'Frame ${index + 1}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
