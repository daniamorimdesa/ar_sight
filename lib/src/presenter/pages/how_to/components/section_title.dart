import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a section title used in the instructions page.
///
/// A [SectionTitle] provides a consistent visual style for grouping related
/// guidance content, such as scan behavior tips and environment recommendations.
class SectionTitle extends StatelessWidget {
  /// Text displayed as the section heading.
  final String title;

  /// Creates a styled section title.
  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
        letterSpacing: -1,
      ),
    );
  }
}