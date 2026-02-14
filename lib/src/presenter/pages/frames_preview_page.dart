import 'dart:typed_data';
import 'package:flutter/material.dart';

class FramesPreviewPage extends StatelessWidget {
  final List<Uint8List> frames;

  const FramesPreviewPage({
    super.key,
    required this.frames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Frames (${frames.length})'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: frames.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frame ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Image.memory(
                      frames[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
