import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'glass_card_dark.dart';
import 'recommendation_row_dark.dart';

class RecommendationsCard extends StatelessWidget {
  final List<String> recommendations;
  final bool isPass;
  final Color accent;

  const RecommendationsCard({
    super.key,
    required this.recommendations,
    required this.isPass,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recommendations.isEmpty)
            Text(
              isPass
                  ? 'No action needed. You can proceed.'
                  : 'No recommendations returned. Try scanning again.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.72),
              ),
            ),
          for (int i = 0; i < recommendations.length; i++) ...[
            RecommendationRowDark(
              index: i + 1,
              text: recommendations[i],
              accent: accent,
            ),
            if (i != recommendations.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Divider(
                  color: Colors.white.withOpacity(0.10),
                  height: 16,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
