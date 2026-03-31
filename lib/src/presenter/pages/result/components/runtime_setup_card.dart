import 'package:flutter/material.dart';

import '../../../../models/scene_diagnosis.dart';
import 'glass_card_dark.dart';
import 'info_row.dart';

class RuntimeSetupCard extends StatelessWidget {
  final SceneDiagnosis diagnosis;
  final Color accent;

  const RuntimeSetupCard({
    super.key,
    required this.diagnosis,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: 'Environment', value: diagnosis.environment, accent: accent),
          const SizedBox(height: 10),
          InfoRow(label: 'Model', value: diagnosis.model, accent: accent),
          const SizedBox(height: 10),
          InfoRow(label: 'Device', value: diagnosis.device, accent: accent),
          const SizedBox(height: 10),
          InfoRow(label: 'Quantization', value: diagnosis.quantization, accent: accent),
          const SizedBox(height: 10),
          InfoRow(label: 'Batch size', value: diagnosis.batchSize.toString(), accent: accent),
        ],
      ),
    );
  }
}
