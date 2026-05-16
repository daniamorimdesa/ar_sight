import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../models/frame_data.dart';
import 'frame_card_image.dart';
import 'frame_status_badge.dart';
import 'frame_viewer_page.dart';

/// Displays a single captured frame as an interactive preview card.
///
/// A [FrameCard] shows the frame image, optionally displays its diagnosis
/// status, and opens a detailed frame viewer when tapped.
class FrameCard extends StatelessWidget {
  /// Captured frame represented as raw image bytes.
  final Uint8List frame;

  /// Zero-based position of the frame within the captured batch.
  final int index;

  /// Optional diagnosis data associated with this frame.
  final FrameData? frameData;

  /// Creates an interactive card for a captured [frame].
  const FrameCard({
    super.key,
    required this.frame,
    required this.index,
    required this.frameData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Open the full-screen frame viewer with optional diagnosis details.
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FrameViewerPage(
              frame: frame,
              index: index,
              frameData: frameData,
            ),
          ),
        );
      },

      // Main card container with border and subtle shadow.
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        // Layer the frame image and the optional status badge.
        child: Stack(
          children: [
            FrameCardImage(frame: frame, index: index),

            if (frameData != null) FrameStatusBadge(isPass: frameData!.isPass),
          ],
        ),
      ),
    );
  }
}
