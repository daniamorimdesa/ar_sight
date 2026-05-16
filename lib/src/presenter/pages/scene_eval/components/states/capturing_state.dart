import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays the active frame capture state.
///
/// A [CapturingState] shows the scan status, remaining time, number of
/// captured frames, and a progress indicator while the scene is being scanned.
class CapturingState extends StatelessWidget {
  /// Remaining capture time, in seconds.
  final int secondsRemaining;

  /// Current capture progress from `0.0` to `1.0`.
  final double progress;

  /// Number of frames captured so far.
  final int capturedFrames;

  /// Creates a capture progress state widget.
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
        // Main capture status message.
        Text(
          'Scanning your environment',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.92),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        // Capture counters displayed above the progress bar.
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

        // Glowing progress bar for the scan progress.
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
