import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../stores/scene_eval_store.dart';
import '../../frames_preview/frames_preview_page.dart';
import 'glass_card_dark.dart';

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
    final total = normalCount + problemCount;
    final normalRatio = total == 0 ? 0.0 : normalCount / total;
    final problemRatio = total == 0 ? 0.0 : problemCount / total;

    const normalGradient = LinearGradient(
      colors: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
    );

    const problemGradient = LinearGradient(
      colors: [Color(0xFFFACC15), Color(0xFFF97316)],
    );

    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OverviewBarRow(
            label: 'Adequate',
            value: normalCount,
            ratio: normalRatio,
            gradient: normalGradient,
            labelColor: const Color(0xFF38BDF8),
          ),

          const SizedBox(height: 12),

          _OverviewBarRow(
            label: 'Attention',
            value: problemCount,
            ratio: problemRatio,
            gradient: problemGradient,
            labelColor: const Color(0xFFF59E0B),
          ),

          const SizedBox(height: 18),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: -2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final store = context.read<SceneEvalStore>();

                  if (store.lastCapturedFrames.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            FramesPreviewPage(frames: store.lastCapturedFrames),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No frames captured yet')),
                    );
                  }
                },
                icon: const Icon(Icons.auto_awesome_mosaic_outlined, color: Colors.white, size: 18),
                label: Text(
                  'explore frames',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    color: Colors.white.withOpacity(0.88),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.30),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewBarRow extends StatelessWidget {
  final String label;
  final int value;
  final double ratio;
  final Gradient gradient;
  final Color labelColor;

  const _OverviewBarRow({
    required this.label,
    required this.value,
    required this.ratio,
    required this.gradient,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 98,
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: labelColor,
            ),
          ),
        ),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(height: 18, color: Colors.white.withOpacity(0.06)),
                FractionallySizedBox(
                  widthFactor: ratio.clamp(0.0, 1.0),
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(gradient: gradient),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 24,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),
      ],
    );
  }
}
