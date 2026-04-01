import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/recommendation_group.dart';
import 'glass_card_dark.dart';
import 'recommendation_row_dark.dart';

class RecommendationsCard extends StatelessWidget {
  final List<String> recommendations;
  final List<RecommendationGroup> recommendationGroups;
  final bool isPass;
  final Color accent;

  const RecommendationsCard({
    super.key,
    required this.recommendations,
    this.recommendationGroups = const [],
    required this.isPass,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    // Se temos recommendationGroups, usar a nova lógica
    if (recommendationGroups.isNotEmpty) {
      return _buildGroupedRecommendations();
    }

    // Fallback para a lógica antiga (compatibilidade)
    return _buildSimpleRecommendations();
  }

  Widget _buildSimpleRecommendations() {
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
                fontSize: 15,
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

  Widget _buildGroupedRecommendations() {
    // Separar grupos: adequados vs problemas
    final adequateGroups = recommendationGroups.where((g) => g.isAdequate).toList();
    final problemGroups = recommendationGroups.where((g) => !g.isAdequate).toList();

    // Se houver problemas, mostrar apenas os problemas
    // Se não houver problemas, mostrar o grupo adequate
    final groupsToShow = problemGroups.isNotEmpty ? problemGroups : adequateGroups;

    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (groupsToShow.isEmpty)
            Text(
              'No recommendations available',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.72),
              ),
            ),
          for (int groupIdx = 0; groupIdx < groupsToShow.length; groupIdx++) ...[
            _buildRecommendationGroup(groupsToShow[groupIdx]),
            if (groupIdx != groupsToShow.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(
                  color: Colors.white.withOpacity(0.10),
                  height: 0,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationGroup(RecommendationGroup group) {
    final isAdequate = group.isAdequate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header com condition e frames (se aplicável)
        if (!isAdequate && group.frameLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              group.frameLabel!,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.85),
                letterSpacing: 0.3,
              ),
            ),
          ),

        // Actions/recommendations
        for (int i = 0; i < group.actions.length; i++) ...[
          _buildActionItem(group.actions[i], i + 1),
          if (i != group.actions.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Divider(
                color: Colors.white.withOpacity(0.10),
                height: 16,
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildActionItem(String action, int index) {
    return RecommendationRowDark(
      index: index,
      text: action,
      accent: accent,
    );
  }
}
