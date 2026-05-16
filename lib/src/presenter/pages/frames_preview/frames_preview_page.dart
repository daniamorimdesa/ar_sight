import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/frame_data.dart';
import 'components/frame_card.dart';

/// Displays the captured frames and their diagnosis information.
///
/// A [FramesPreviewPage] presents the latest frames captured by the camera in
/// a grid layout. When frame-level diagnosis data is available, each frame can
/// also display its associated quality status and metrics through [FrameCard].
class FramesPreviewPage extends StatelessWidget {
  /// Captured frame images represented as raw image bytes.
  final List<Uint8List> frames;

  /// Optional diagnosis data associated with each captured frame.
  ///
  /// When provided, each [FrameData] entry is matched to the frame at the same
  /// index in [frames].
  final List<FrameData>? frameDataList;

  /// Creates a frame preview page for the provided [frames].
  const FramesPreviewPage({
    super.key,
    required this.frames,
    this.frameDataList,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: Colors.white,

      // Top navigation bar for the frame analysis screen.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          'Frame Analysis',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Responsive grid displaying all captured frames.
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: frames.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 9 / 16,
        ),
        itemBuilder: (context, index) {
          // Match each frame with its diagnosis data when available.
          final frameData =
              frameDataList != null && index < frameDataList!.length
              ? frameDataList![index]
              : null;

          return FrameCard(
            frame: frames[index],
            index: index,
            frameData: frameData,
          );
        },
      ),
    );
  }
}
