import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/recommendation_group.dart';
import 'glass_card_dark.dart';
import 'recommendation_row_dark.dart';

/// Displays diagnosis recommendations in the result page.
///
/// A [RecommendationsCard] can render either a flat list of recommendations or
/// grouped recommendations associated with specific scene conditions and frame
/// indices.
class RecommendationsCard extends StatelessWidget {
  /// Flat list of recommendations returned by the backend.
  final List<String> recommendations;

  /// Recommendations grouped by diagnosis condition and affected frames.
  final List<RecommendationGroup> recommendationGroups;

  /// Whether the overall scene diagnosis passed.
  final bool isPass;

  /// Accent color associated with the overall diagnosis status.
  final Color accent;

  /// Creates a recommendation card for the diagnosis result.
  const RecommendationsCard({
    super.key,
    required this.recommendations,
    this.recommendationGroups = const [],
    required this.isPass,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    // Prefer grouped recommendations when frame-level grouping is available.
    if (recommendationGroups.isNotEmpty) {
      return _buildGroupedRecommendations();
    }

    // Fallback for older or simpler backend responses.
    return _buildSimpleRecommendations();
  }

  /// Builds a fallback recommendation list from a flat string collection.
  Widget _buildSimpleRecommendations() {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Empty-state message.
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

          // Flat recommendation list.
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

  /// Builds recommendations grouped by scene condition.
  Widget _buildGroupedRecommendations() {
    // Separate high-level adequate groups from problem-specific groups.
    final adequateGroups = recommendationGroups
        .where((group) => group.isAdequate)
        .toList();

    final problemGroups = recommendationGroups
        .where((group) => !group.isAdequate)
        .toList();

    // Prioritize problem-specific recommendations when they are available.
    final groupsToShow = problemGroups.isNotEmpty
        ? problemGroups
        : adequateGroups;

    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Empty-state message.
          if (groupsToShow.isEmpty)
            Text(
              'No recommendations available',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.72),
              ),
            ),

          // Grouped recommendation sections.
          for (
            int groupIdx = 0;
            groupIdx < groupsToShow.length;
            groupIdx++
          ) ...[
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

  /// Builds one recommendation group with an optional frame label.
  Widget _buildRecommendationGroup(RecommendationGroup group) {
    final isAdequate = group.isAdequate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Condition header with affected frames, when applicable.
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

        // Corrective actions for this condition.
        for (int i = 0; i < group.actions.length; i++) ...[
          _buildActionItem(group.actions[i], i + 1),
          if (i != group.actions.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Divider(color: Colors.white.withOpacity(0.10), height: 16),
            ),
        ],
      ],
    );
  }

  /// Builds a numbered recommendation action row.
  Widget _buildActionItem(String action, int index) {
    return RecommendationRowDark(index: index, text: action, accent: accent);
  }
}
