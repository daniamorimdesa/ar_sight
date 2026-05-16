import 'package:flutter/material.dart';
import '../../../models/scene_diagnosis.dart';
import '../scene_eval/scene_eval_page.dart';
import 'components/frame_overview_card.dart';
import 'components/hero_section.dart';
import 'components/performance_section.dart';
import 'components/recommendations_card.dart';
import 'components/runtime_setup_card.dart';
import 'components/section_title.dart';
import 'components/summary_card.dart';

/// Displays the final diagnosis result for an evaluated scene.
///
/// A [ResultPage] organizes the scene diagnosis into visual sections,
/// including the main status, summary, frame overview, recommendations,
/// performance metrics, and runtime setup information.
class ResultPage extends StatelessWidget {
  /// Structured diagnosis result returned by the evaluation pipeline.
  final SceneDiagnosis diagnosis;

  /// Creates a result page for the provided [diagnosis].
  const ResultPage({super.key, required this.diagnosis});

  /// Whether the evaluated scene passed the diagnosis criteria.
  bool get _isPass => diagnosis.status.toLowerCase() == 'pass';

  /// Main accent color derived from the diagnosis status.
  Color get _accent =>
      _isPass ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,

      // Transparent navigation bar over the result background.
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
        actions: [
          // Restart the scene evaluation flow.
          IconButton(
            tooltip: 'Run again',
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SceneEvalPage()),
              );
            },
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 28,
            ),
          ),

          // Return to the first route in the navigation stack.
          IconButton(
            tooltip: 'Home',
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(
              Icons.home_rounded,
              color: Colors.white.withOpacity(0.9),
              size: 28,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Base gradient with dark blue and purple tones.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e).withOpacity(0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Soft radial overlay for depth and color variation.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.3, -0.8),
                  radius: 1.5,
                  colors: [
                    const Color(0xFF00d4ff).withOpacity(0.08),
                    const Color(0xFF7c3aed).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Secondary decorative accent spot.
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF7c3aed).withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Dark overlay to improve content readability.
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),

          // Scrollable diagnosis content.
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                // Main result status area.
                HeroSection(isPass: _isPass, accent: _accent),

                const SizedBox(height: 10),

                Divider(color: Colors.white.withOpacity(0.10)),

                const SizedBox(height: 10),

                // General scene diagnosis summary.
                SectionTitle(title: 'SCENE SUMMARY'),
                const SizedBox(height: 10),
                SummaryCard(diagnosis: diagnosis, accent: _accent),

                const SizedBox(height: 18),

                // Aggregated frame-level status overview.
                SectionTitle(title: 'FRAME OVERVIEW'),
                const SizedBox(height: 10),
                FrameOverviewCard(
                  normalCount: diagnosis.normalCount,
                  problemCount: diagnosis.problemCount,
                  diagnosis: diagnosis,
                ),

                const SizedBox(height: 18),

                // Recommended actions based on detected scene conditions.
                SectionTitle(title: 'RECOMMENDATIONS'),
                const SizedBox(height: 10),
                RecommendationsCard(
                  recommendations: diagnosis.recommendations,
                  recommendationGroups: diagnosis.recommendationGroups,
                  isPass: _isPass,
                  accent: _accent,
                ),

                const SizedBox(height: 18),

                // Processing and validation performance metrics.
                SectionTitle(title: 'PERFORMANCE'),
                const SizedBox(height: 10),
                PerformanceSection(diagnosis: diagnosis, accent: _accent),

                const SizedBox(height: 18),

                // Backend runtime and model configuration details.
                SectionTitle(title: 'RUNTIME SETUP'),
                const SizedBox(height: 10),
                RuntimeSetupCard(
                  diagnosis: diagnosis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
