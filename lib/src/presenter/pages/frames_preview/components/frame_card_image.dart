import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a captured frame image with a gradient overlay and frame label.
///
/// A [FrameCardImage] is used inside a frame preview card to render the raw
/// image bytes and identify the frame position within the captured batch.
class FrameCardImage extends StatelessWidget {
  /// Captured frame represented as raw image bytes.
  final Uint8List frame;

  /// Zero-based position of the frame within the captured batch.
  final int index;

  /// Creates an image preview for a captured [frame].
  const FrameCardImage({super.key, required this.frame, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Captured frame image.
        Positioned.fill(child: Image.memory(frame, fit: BoxFit.cover)),

        // Bottom gradient overlay to improve label readability.
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
        ),

        // User-facing frame identifier.
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
