// result_page: exibe resultados da análise, incluindo diagnóstico, métricas e recomendações.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/scene_diagnosis.dart';
import '../scene_eval/scene_eval_page.dart';
import 'components/status_icon.dart';
import 'components/glass_card_dark.dart';
import 'components/metric_card.dart';
import 'components/recommendation_row_dark.dart';
import 'components/metric_item.dart';

class ResultPage extends StatelessWidget {
  final SceneDiagnosis diagnosis;

  const ResultPage({super.key, required this.diagnosis});

  bool get _isPass => diagnosis.status.toLowerCase() == 'pass';

  Color get _accent => _isPass ? const Color(0xFF3B82F6) : const Color(0xFFFF5B6A);

  String get _title => _isPass ? 'SCENE READY' : 'NEEDS IMPROVEMENTS';

  String get _subtitle =>
      _isPass ? 'Environment analyzed successfully' : 'Environment needs adjustments';

  @override
  Widget build(BuildContext context) {
    final metrics = buildMetricsFromEvidence(diagnosis.evidenceMetrics);

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
            icon: Icon(Icons.refresh_rounded, color: Colors.white.withOpacity(0.9), size: 28),
          ),
          IconButton(
            tooltip: 'Home',
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            icon: Icon(Icons.home_rounded, color: Colors.white.withOpacity(0.9), size: 28),
          ),
        ],
      ),

      body: Stack(
        children: [
          // Background: dark + glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.9),
                  radius: 1.2,
                  colors: [
                    _accent.withOpacity(0.20),
                    const Color(0xFF05070B),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // subtle vignette
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.28)),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                // HERO (check + title + subtitle)
                Column(
                  children: [
                    StatusIcon(accent: _accent, isPass: _isPass),
                    const SizedBox(height: 14),
                    Text(
                      _title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(0.70),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Divider(color: Colors.white.withOpacity(0.10)),
                const SizedBox(height: 18),

                // ANALYSIS RESULTS
                GlassCardDark(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ANALYSIS RESULTS',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.88),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        diagnosis.reason,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                          color: Colors.white.withOpacity(0.82),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        diagnosis.explanation,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          height: 1.45,
                          color: Colors.white.withOpacity(0.68),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: _accent.withOpacity(0.9)),
                          const SizedBox(width: 8),
                          Text(
                            'Processing time: ',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white.withOpacity(0.55),
                            ),
                          ),
                          Text(
                            diagnosis.processingTime,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _accent.withOpacity(0.95),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // DETECTED METRICS (GRID)
                Text(
                  'DETECTED METRICS',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.80),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, i) {
                    final m = metrics[i];
                    return MetricCard(
                      icon: m.icon,
                      title: m.title,
                      value: m.value,
                      accent: _accent,
                    );
                  },
                ),

                const SizedBox(height: 18),

                // RECOMMENDATIONS
                Text(
                  'RECOMMENDATIONS',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.80),
                  ),
                ),
                const SizedBox(height: 10),

                GlassCardDark(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (diagnosis.recommendations.isEmpty)
                        Text(
                          _isPass
                              ? 'No action needed. You can proceed.'
                              : 'No recommendations returned. Try scanning again.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            color: Colors.white.withOpacity(0.72),
                          ),
                        ),

                      for (int i = 0; i < diagnosis.recommendations.length; i++) ...[
                        RecommendationRowDark(
                          index: i + 1,
                          text: diagnosis.recommendations[i],
                          accent: _accent,
                        ),
                        if (i != diagnosis.recommendations.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 34),
                            child: Divider(color: Colors.white.withOpacity(0.10), height: 16),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


