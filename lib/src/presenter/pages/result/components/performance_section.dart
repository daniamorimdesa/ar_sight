import 'package:flutter/material.dart';

import '../../../../models/scene_diagnosis.dart';
import 'stat_card.dart';

class PerformanceSection extends StatelessWidget {
  final SceneDiagnosis diagnosis;
  final Color accent;

  const PerformanceSection({
    super.key,
    required this.diagnosis,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 18 * 2 - 12 * 1) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statBox(
          title: 'PDI Total',
          value: '${diagnosis.pdiTotalMs.toStringAsFixed(1)} ms',
          icon: Icons.image_search_rounded,
          accent: accent,
          width: cardWidth,
        ),
        _statBox(
          title: 'PDI / Image',
          value: '${diagnosis.pdiPerImageMs.toStringAsFixed(1)} ms',
          icon: Icons.grid_view_rounded,
          accent: accent,
          width: cardWidth,
        ),
        _statBox(
          title: 'SLM Total',
          value: '${diagnosis.slmTotalS.toStringAsFixed(2)} s',
          icon: Icons.psychology_alt_rounded,
          accent: accent,
          width: cardWidth,
        ),
        _statBox(
          title: 'SLM / Diagnosis',
          value: '${diagnosis.slmPerDiagnosisS.toStringAsFixed(2)} s',
          icon: Icons.auto_awesome_rounded,
          accent: accent,
          width: cardWidth,
        ),
      ],
    );
  }

  Widget _statBox({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: StatCard(
        title: title,
        value: value,
        icon: icon,
        accent: accent,
      ),
    );
  }
}
