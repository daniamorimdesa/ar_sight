import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/frame_data.dart';
import 'frame_details_modal.dart';

/// Displays a selected captured frame in a larger viewer.
///
/// A [FrameViewerPage] allows the user to inspect a captured frame using an
/// [InteractiveViewer]. When diagnosis data is available, the page also
/// provides access to a detailed bottom-sheet modal.
class FrameViewerPage extends StatelessWidget {
  /// Captured frame represented as raw image bytes.
  final Uint8List frame;

  /// Zero-based position of the frame within the captured batch.
  final int index;

  /// Optional diagnosis data associated with this frame.
  final FrameData? frameData;

  /// Creates a viewer page for a selected [frame].
  const FrameViewerPage({
    super.key,
    required this.frame,
    required this.index,
    this.frameData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Top navigation bar with frame identifier and optional details action.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),

        // User-facing frame title.
        title: Row(
          children: [
            Text(
              'Frame ${index + 1}',
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        // Show the details button only when diagnosis data is available.
        actions: [
          if (frameData != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDetailsModal(context);
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: Text(
                    'See Details',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      // Zoomable frame viewer.
      body: Center(child: InteractiveViewer(child: Image.memory(frame))),
    );
  }

  /// Opens the bottom-sheet modal with frame diagnosis details.
  ///
  /// The modal is not shown when [frameData] is unavailable.
  void _showDetailsModal(BuildContext context) {
    if (frameData == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FrameDetailsModal(frameData: frameData!),
    );
  }
}
