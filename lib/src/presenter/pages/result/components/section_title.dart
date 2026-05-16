import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a compact section title used in the result page.
///
/// A [SectionTitle] provides a consistent uppercase heading style for grouping
/// diagnosis sections such as summary, frame overview, recommendations,
/// performance, and runtime setup.
class SectionTitle extends StatelessWidget {
  /// Text displayed as the section heading.
  final String title;

  /// Creates a styled section title for result sections.
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(0.80),
      ),
    );
  }
}
