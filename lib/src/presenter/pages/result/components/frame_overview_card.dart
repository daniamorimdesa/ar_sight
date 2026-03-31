import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../stores/scene_eval_store.dart';
import '../../frames_preview/frames_preview_page.dart';
import 'glass_card_dark.dart';
import 'stat_card.dart';

class FrameOverviewCard extends StatelessWidget {
  final int normalCount;
  final int problemCount;
  final Color accent;

  const FrameOverviewCard({
    super.key,
    required this.normalCount,
    required this.problemCount,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCardDark(
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 160,
                child: StatCard(
                  title: 'Normal Frames',
                  value: normalCount.toString(),
                  icon: Icons.check_circle_outline_rounded,
                  accent: const Color(0xFF22C55E),
                ),
              ),
              SizedBox(
                width: 160,
                child: StatCard(
                  title: 'Problem Frames',
                  value: problemCount.toString(),
                  icon: Icons.error_outline_rounded,
                  accent: const Color(0xFFFF5B6A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final store = context.read<SceneEvalStore>();
                if (store.lastCapturedFrames.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FramesPreviewPage(
                        frames: store.lastCapturedFrames,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No frames captured yet')),
                  );
                }
              },
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('View frame details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.88),
                side: BorderSide(color: Colors.white.withOpacity(0.14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
