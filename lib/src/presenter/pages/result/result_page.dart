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

class ResultPage extends StatelessWidget {
  final SceneDiagnosis diagnosis;

  const ResultPage({super.key, required this.diagnosis});

  bool get _isPass => diagnosis.status.toLowerCase() == 'pass';

  Color get _accent =>
      _isPass ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B);

  String get _title => _isPass ? 'SCENE READY' : 'NEEDS IMPROVEMENTS';

  String get _subtitle => _isPass
      ? 'This scene meets the conditions for AR experiences'
      : 'This scene needs a few adjustments before AR use';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.9)),
        actions: [
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
          IconButton(
            tooltip: 'Home',
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
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
          // Base gradient with purple and cyan tones
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
          // Radial gradient overlay for accent color
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
          // Secondary accent spot
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
          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                HeroSection(isPass: _isPass, accent: _accent),

                const SizedBox(height: 10),

                Divider(color: Colors.white.withOpacity(0.10)),

                const SizedBox(height: 10),

                SectionTitle(title: 'SCENE SUMMARY'),
                const SizedBox(height: 10),
                SummaryCard(diagnosis: diagnosis, accent: _accent),

                const SizedBox(height: 18),

                SectionTitle(title: 'FRAME OVERVIEW'),
                const SizedBox(height: 10),
                FrameOverviewCard(
                  normalCount: diagnosis.normalCount,
                  problemCount: diagnosis.problemCount,
                  accent: _accent,
                  diagnosis: diagnosis,
                ),

                const SizedBox(height: 18),

                SectionTitle(title: 'RECOMMENDATIONS'),
                const SizedBox(height: 10),
                RecommendationsCard(
                  recommendations: diagnosis.recommendations,
                  recommendationGroups: diagnosis.recommendationGroups,
                  isPass: _isPass,
                  accent: _accent,
                ),

                const SizedBox(height: 18),

                SectionTitle(title: 'PERFORMANCE'),
                const SizedBox(height: 10),
                PerformanceSection(diagnosis: diagnosis, accent: _accent),

                const SizedBox(height: 18),

                SectionTitle(title: 'RUNTIME SETUP'),
                const SizedBox(height: 10),
                RuntimeSetupCard(
                  diagnosis: diagnosis,
                  accent: const Color.fromARGB(
                    255,
                    144,
                    129,
                    231,
                  ).withOpacity(0.92),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
