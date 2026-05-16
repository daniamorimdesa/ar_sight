import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/scene_diagnosis.dart';
import 'glass_card_dark.dart';

/// Displays runtime configuration metadata for the diagnosis pipeline.
///
/// A [RuntimeSetupCard] shows information about the backend environment,
/// language model, and batch size used to evaluate the scene.
class RuntimeSetupCard extends StatelessWidget {
  /// Diagnosis result containing runtime setup information.
  final SceneDiagnosis diagnosis;

  /// Creates a runtime setup card for the provided [diagnosis].
  const RuntimeSetupCard({
    super.key,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Backend execution environment.
        GlassCardDark(
          child: _setupRow(
            label: 'Environment',
            value: diagnosis.environment,
            icon: Icons.developer_board_rounded,
            iconColor: const Color.fromARGB(255, 112, 212, 255),
          ),
        ),

        const SizedBox(height: 12),

        // Small language model used by the backend.
        GlassCardDark(
          child: _setupRow(
            label: 'Model',
            value: diagnosis.model,
            icon: Icons.hub_outlined,
            iconColor: const Color.fromARGB(255, 34, 255, 200),
          ),
        ),

        const SizedBox(height: 12),

        // Number of frames processed in the diagnosis batch.
        GlassCardDark(
          child: _setupRow(
            label: 'Batch size',
            value: diagnosis.batchSize.toString(),
            icon: Icons.layers_rounded,
            iconColor: const Color.fromARGB(255, 255, 214, 124),
          ),
        ),
      ],
    );
  }

  /// Builds one runtime setup row with an icon, label, and value.
  Widget _setupRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        // Runtime metadata icon.
        Icon(icon, color: iconColor, size: 20),

        const SizedBox(width: 10),

        // Metadata label.
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),

        const SizedBox(width: 8),

        // Metadata value.
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ),
      ],
    );
  }
}
