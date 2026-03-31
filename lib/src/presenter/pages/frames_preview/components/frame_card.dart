import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../models/frame_data.dart';
import 'frame_card_image.dart';
import 'frame_status_badge.dart';
import 'frame_viewer_page.dart';

class FrameCard extends StatelessWidget {
  final Uint8List frame;
  final int index;
  final FrameData? frameData;
  final Color accent;

  const FrameCard({
    super.key,
    required this.frame,
    required this.index,
    required this.frameData,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            FrameCardImage(
              frame: frame,
              index: index,
            ),
            if (frameData != null)
              FrameStatusBadge(isPass: frameData!.isPass),
          ],
        ),
      ),
    );
  }
}
