import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      _isPass ? const Color(0xFF22C55E) : const Color(0xFFFF5B6A);

  String get _title => _isPass ? 'SCENE READY' : 'NEEDS IMPROVEMENTS';

  String get _subtitle => _isPass
      ? 'Your environment is suitable for AR experiences'
      : 'Your environment needs adjustments before AR use';

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
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.9),
                  radius: 1.2,
                  colors: [
                    _accent.withOpacity(0.16),
                    const Color(0xFF05070B),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.28)),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                HeroSection(isPass: _isPass, accent: _accent),
                const SizedBox(height: 18),
                Divider(color: Colors.white.withOpacity(0.10)),
                const SizedBox(height: 18),
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
                ),
                const SizedBox(height: 18),
                SectionTitle(title: 'RECOMMENDATIONS'),
                const SizedBox(height: 10),
                RecommendationsCard(
                  recommendations: diagnosis.recommendations,
                  isPass: _isPass,
                  accent: _accent,
                ),
                const SizedBox(height: 18),
                SectionTitle(title: 'RUNTIME SETUP'),
                const SizedBox(height: 10),
                RuntimeSetupCard(diagnosis: diagnosis, accent: _accent),
                const SizedBox(height: 18),
                SectionTitle(title: 'PERFORMANCE'),
                const SizedBox(height: 10),
                PerformanceSection(diagnosis: diagnosis, accent: _accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
