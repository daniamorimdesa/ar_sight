import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/frame_data.dart';
import 'frame_details_modal.dart';

class FrameViewerPage extends StatelessWidget {
  final Uint8List frame;
  final int index;
  final FrameData? frameData;

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black87),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.memory(frame),
        ),
      ),
    );
  }

  void _showDetailsModal(BuildContext context) {
    if (frameData == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FrameDetailsModal(frameData: frameData!),
    );
  }
}
