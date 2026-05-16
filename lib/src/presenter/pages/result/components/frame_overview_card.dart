import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/frame_data.dart';
import '../../../../models/scene_diagnosis.dart';
import '../../../stores/scene_eval_store.dart';
import '../../frames_preview/frames_preview_page.dart';
import 'glass_card_dark.dart';

/// Displays an overview of frame-level diagnosis results.
///
/// A [FrameOverviewCard] summarizes how many frames were classified as
/// adequate or requiring attention. It also provides a shortcut to inspect the
/// captured frames in detail.
class FrameOverviewCard extends StatelessWidget {
  /// Number of frames classified as adequate.
  final int normalCount;

  /// Number of frames classified as requiring attention.
  final int problemCount;

  /// Optional full diagnosis data used to build frame-level details.
  final SceneDiagnosis? diagnosis;

  /// Creates a frame overview card.
  const FrameOverviewCard({
    super.key,
    required this.normalCount,
    required this.problemCount,
    this.diagnosis,
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
          // Progress bar for frames classified as adequate.
          _OverviewBarRow(
            label: 'Adequate',
            value: normalCount,
            ratio: normalRatio,
            gradient: normalGradient,
            labelColor: const Color(0xFF38BDF8),
          ),

          const SizedBox(height: 12),

          // Progress bar for frames requiring attention.
          _OverviewBarRow(
            label: 'Attention',
            value: problemCount,
            ratio: problemRatio,
            gradient: problemGradient,
            labelColor: const Color(0xFFF59E0B),
          ),

          const SizedBox(height: 18),

          // Button used to open the captured frame preview page.
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
                    // Convert raw diagnosis frames into UI-friendly frame data.
                    final frameDataList = diagnosis?.frames
                        .asMap()
                        .entries
                        .map((e) => FrameData.fromBackend(e.value, e.key))
                        .toList();

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FramesPreviewPage(
                          frames: store.lastCapturedFrames,
                          frameDataList: frameDataList,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No frames captured yet')),
                    );
                  }
                },
                icon: const Icon(
                  Icons.auto_awesome_mosaic_outlined,
                  color: Colors.white,
                  size: 18,
                ),
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

/// Displays a labeled horizontal progress bar for one frame category.
///
/// The [_OverviewBarRow] shows the category label, proportional bar, and
/// absolute frame count.
class _OverviewBarRow extends StatelessWidget {
  /// Category label displayed on the left side.
  final String label;

  /// Number of frames in this category.
  final int value;

  /// Proportional value used to fill the progress bar.
  ///
  /// Expected range is from `0.0` to `1.0`.
  final double ratio;

  /// Gradient used to fill the progress bar.
  final Gradient gradient;

  /// Color used for the label and frame count.
  final Color labelColor;

  /// Creates a frame overview progress row.
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
        // Category label.
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

        // Proportional progress bar.
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                // Background track.
                Container(height: 18, color: Colors.white.withOpacity(0.06)),

                // Filled portion based on the category ratio.
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

        // Absolute frame count.
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
