import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/frame_card.dart';

class FramesPreviewPage extends StatelessWidget {
  final List<Uint8List> frames;

  const FramesPreviewPage({
    super.key,
    required this.frames,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: false,

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: Text(
          'Last Captured Frames',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          itemCount: frames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 9 / 16,
          ),
          itemBuilder: (context, index) {
            return FrameCard(
              frame: frames[index],
              index: index,
              accent: accent,
            );
          },
        ),
      ),
    );
  }
}

enum FrameQuality { good, medium, low }

extension FrameQualityExt on FrameQuality {
  Color get color {
    switch (this) {
      case FrameQuality.good:
        return const Color(0xFF00D4FF);
      case FrameQuality.medium:
        return const Color(0xFFFFB020);
      case FrameQuality.low:
        return const Color(0xFFFF5B6A);
    }
  }

  String get label {
    switch (this) {
      case FrameQuality.good:
        return "GOOD";
      case FrameQuality.medium:
        return "OK";
      case FrameQuality.low:
        return "LOW";
    }
  }
}


