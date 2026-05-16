import 'package:flutter/material.dart';
import '../../../../models/scene_diagnosis.dart';
import 'stat_card.dart';

/// Displays performance metrics for the diagnosis pipeline.
///
/// A [PerformanceSection] presents timing information for deterministic image
/// processing and small language model inference using a responsive two-column
/// layout.
class PerformanceSection extends StatelessWidget {
  /// Diagnosis result containing the performance metrics to display.
  final SceneDiagnosis diagnosis;

  /// Accent color associated with the overall diagnosis status.
  final Color accent;

  /// Creates a performance metrics section for the provided [diagnosis].
  const PerformanceSection({
    super.key,
    required this.diagnosis,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Compute the width required to fit two cards per row with fixed spacing.
    final cardWidth = (screenWidth - 18 * 2 - 12 * 1) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Total deterministic image processing time.
        _statBox(
          title: 'PDI Total',
          value: '${diagnosis.pdiTotalMs.toStringAsFixed(1)} ms',
          icon: Icons.image_search_rounded,
          accent: accent,
          iconColor: const Color.fromARGB(255, 183, 228, 198),
          width: cardWidth,
        ),

        // Average deterministic image processing time per frame.
        _statBox(
          title: 'PDI / Image',
          value: '${diagnosis.pdiPerImageMs.toStringAsFixed(1)} ms',
          icon: Icons.grid_view_rounded,
          accent: accent,
          iconColor: const Color(0xFFA78BFA),
          width: cardWidth,
        ),

        // Total small language model inference time.
        _statBox(
          title: 'SLM Total',
          value: '${diagnosis.slmTotalS.toStringAsFixed(2)} s',
          icon: Icons.psychology_alt_rounded,
          accent: accent,
          iconColor: const Color(0xFF06B6D4),
          width: cardWidth,
        ),

        // Average small language model time per diagnosis.
        _statBox(
          title: 'SLM / Diagnosis',
          value: '${diagnosis.slmPerDiagnosisS.toStringAsFixed(2)} s',
          icon: Icons.auto_awesome_rounded,
          accent: accent,
          iconColor: const Color(0xFFF59E0B),
          width: cardWidth,
        ),
      ],
    );
  }

  /// Builds a fixed-width [StatCard] for a single performance metric.
  Widget _statBox({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
    required double width,
    Color? iconColor,
  }) {
    return SizedBox(
      width: width,
      child: StatCard(
        title: title,
        value: value,
        icon: icon,
        accent: accent,
        iconColor: iconColor,
      ),
    );
  }
}
