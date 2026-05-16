import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays the idle guidance shown before scene capture starts.
///
/// An [IdleState] provides short instructions to help the user perform a
/// stable scan and capture useful visual features for AR tracking.
class IdleState extends StatelessWidget {
  /// Creates the idle guidance state.
  const IdleState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary scan guidance.
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

        // Secondary environment guidance.
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
