import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/scene_diagnosis.dart';
import 'glass_card_dark.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassCardDark(
          child: _setupRow(
            label: 'Environment',
            value: diagnosis.environment,
            icon: Icons.developer_board_rounded,
            iconColor: const Color.fromARGB(255, 112, 212, 255), // Sky Blue
          ),
        ),
        const SizedBox(height: 12),
        GlassCardDark(
          child: _setupRow(
            label: 'Model',
            value: diagnosis.model,
            icon: Icons.hub_outlined,
            iconColor: const Color.fromARGB(255, 34, 255, 200), // Pink/Magenta
          ),
        ),
        const SizedBox(height: 12),
        GlassCardDark(
          child: _setupRow(
            label: 'Batch size',
            value: diagnosis.batchSize.toString(),
            icon: Icons.layers_rounded,
            iconColor: const Color.fromARGB(255, 255, 214, 124), // Orange
          ),
        ),
      ],
    );
  }

  Widget _setupRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
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
