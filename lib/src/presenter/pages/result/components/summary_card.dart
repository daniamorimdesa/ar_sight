import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/scene_diagnosis.dart';
import 'glass_card_dark.dart';
import 'info_row.dart';

class SummaryCard extends StatelessWidget {
  final SceneDiagnosis diagnosis;
  final Color accent;

  const SummaryCard({
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
          Text(
            diagnosis.explanation,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.6,
              color: accent,
            ),
          ),
          const SizedBox(height: 14),
          InfoRow(
            label: 'Risk level',
            value: diagnosis.riskLevel.toUpperCase(),
            accent: accent,
          ),
          const SizedBox(height: 8),
          InfoRow(
            label: 'Dominant condition',
            value: diagnosis.dominantLabel,
            accent: accent,
          ),
          const SizedBox(height: 8),
          InfoRow(
            label: 'Processing time',
            value: diagnosis.processingTime,
            accent: accent,
          ),
        ],
      ),
    );
  }
}
