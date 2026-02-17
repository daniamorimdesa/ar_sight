import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrameViewerPage extends StatelessWidget {
  final Uint8List frame;
  final int index;

  const FrameViewerPage({
    super.key,
    required this.frame,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: Text(
          'Frame ${index + 1}',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Center(
        child: InteractiveViewer(
          child: Image.memory(frame),
        ),
      ),
    );
  }
}
