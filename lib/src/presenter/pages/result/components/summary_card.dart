import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/scene_diagnosis.dart';
import 'glass_card_dark.dart';
import 'info_row.dart';

/// Displays the main textual summary of the scene diagnosis.
///
/// A [SummaryCard] presents the natural language explanation returned by the
/// backend, followed by key diagnosis information such as risk level, dominant
/// condition, and processing time.
class SummaryCard extends StatelessWidget {
  /// Diagnosis result containing the summary information to display.
  final SceneDiagnosis diagnosis;

  /// Accent color associated with the overall diagnosis status.
  final Color accent;

  /// Creates a summary card for the provided [diagnosis].
  const SummaryCard({super.key, required this.diagnosis, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Natural language diagnosis explanation.
          Text(
            diagnosis.explanation,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.6,
              color: Colors.white.withOpacity(0.80),
            ),
          ),

          const SizedBox(height: 14),

          // Overall risk level assigned to the scene.
          InfoRow(
            label: 'Risk level',
            value: diagnosis.riskLevel.toUpperCase(),
            accent: accent,
            icon: Icons.speed_rounded,
            iconColor: Colors.white,
            labelColor: Colors.white,
          ),

          const SizedBox(height: 8),

          // Most relevant or frequent condition detected in the batch.
          InfoRow(
            label: 'Dominant condition',
            value: diagnosis.dominantLabel,
            accent: Colors.white,
            icon: Icons.camera_enhance_rounded,
            iconColor: Colors.white,
            labelColor: Colors.white,
          ),

          const SizedBox(height: 8),

          // End-to-end processing time reported by the backend.
          InfoRow(
            label: 'Processing time',
            value: diagnosis.processingTime,
            accent: Colors.white,
            icon: Icons.schedule_rounded,
            iconColor: Colors.white,
            labelColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
