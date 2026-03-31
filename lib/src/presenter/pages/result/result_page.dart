import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/scene_diagnosis.dart';
import '../../stores/scene_eval_store.dart';
import '../frames_preview/frames_preview_page.dart';
import '../scene_eval/scene_eval_page.dart';
import 'components/glass_card_dark.dart';
import 'components/recommendation_row_dark.dart';
import 'components/status_icon.dart';

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
                _buildHero(),
                const SizedBox(height: 18),
                Divider(color: Colors.white.withOpacity(0.10)),
                const SizedBox(height: 18),

                _sectionTitle('SCENE SUMMARY'),
                const SizedBox(height: 10),
                _buildSummaryCard(),

                const SizedBox(height: 18),
                _sectionTitle('FRAME OVERVIEW'),
                const SizedBox(height: 10),
                _buildFrameOverview(context),

                const SizedBox(height: 18),
                _sectionTitle('RECOMMENDATIONS'),
                const SizedBox(height: 10),
                _buildRecommendationsCard(),

                const SizedBox(height: 18),
                _sectionTitle('RUNTIME SETUP'),
                const SizedBox(height: 10),
                _buildRuntimeCard(),

                const SizedBox(height: 18),
                _sectionTitle('PERFORMANCE'),
                const SizedBox(height: 10),
                _buildPerformanceWrap(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
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
      ],
    );
  }

  Widget _buildSummaryCard() {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            diagnosis.explanation,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.6,
              color: _accent,
            ),
          ),
          const SizedBox(height: 14),
          _InfoRow(
            label: 'Risk level',
            value: diagnosis.riskLevel.toUpperCase(),
            accent: _accent,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Dominant condition',
            value: diagnosis.dominantLabel,
            accent: _accent,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Processing time',
            value: diagnosis.processingTime,
            accent: _accent,
          ),
        ],
      ),
    );
  }

  Widget _buildFrameOverview(BuildContext context) {
    return GlassCardDark(
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 160,
                child: _StatCard(
                  title: 'Normal Frames',
                  value: diagnosis.normalCount.toString(),
                  icon: Icons.check_circle_outline_rounded,
                  accent: const Color(0xFF22C55E),
                ),
              ),
              SizedBox(
                width: 160,
                child: _StatCard(
                  title: 'Problem Frames',
                  value: diagnosis.problemCount.toString(),
                  icon: Icons.error_outline_rounded,
                  accent: const Color(0xFFFF5B6A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final store = context.read<SceneEvalStore>();
                if (store.lastCapturedFrames.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FramesPreviewPage(
                        frames: store.lastCapturedFrames,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No frames captured yet')),
                  );
                }
              },
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('View frame details'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white.withOpacity(0.88),
                side: BorderSide(color: Colors.white.withOpacity(0.14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuntimeCard() {
    return GlassCardDark(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Environment', value: diagnosis.environment, accent: _accent),
          const SizedBox(height: 10),
          _InfoRow(label: 'Model', value: diagnosis.model, accent: _accent),
          const SizedBox(height: 10),
          _InfoRow(label: 'Device', value: diagnosis.device, accent: _accent),
          const SizedBox(height: 10),
          _InfoRow(label: 'Quantization', value: diagnosis.quantization, accent: _accent),
          const SizedBox(height: 10),
          _InfoRow(label: 'Batch size', value: diagnosis.batchSize.toString(), accent: _accent),
        ],
      ),
    );
  }

  Widget _buildPerformanceWrap() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statBox(
          title: 'PDI Total',
          value: '${diagnosis.pdiTotalMs.toStringAsFixed(1)} ms',
          icon: Icons.image_search_rounded,
          accent: _accent,
        ),
        _statBox(
          title: 'PDI / Image',
          value: '${diagnosis.pdiPerImageMs.toStringAsFixed(1)} ms',
          icon: Icons.grid_view_rounded,
          accent: _accent,
        ),
        _statBox(
          title: 'SLM Total',
          value: '${diagnosis.slmTotalS.toStringAsFixed(2)} s',
          icon: Icons.psychology_alt_rounded,
          accent: _accent,
        ),
        _statBox(
          title: 'SLM / Diagnosis',
          value: '${diagnosis.slmPerDiagnosisS.toStringAsFixed(2)} s',
          icon: Icons.auto_awesome_rounded,
          accent: _accent,
        ),
        _statBox(
          title: 'Total Time',
          value: '${diagnosis.totalS.toStringAsFixed(2)} s',
          icon: Icons.timer_outlined,
          accent: _accent,
        ),
        _statBox(
          title: 'Target Met',
          value: diagnosis.targetMet ? 'YES' : 'NO',
          icon: diagnosis.targetMet
              ? Icons.check_circle_outline_rounded
              : Icons.highlight_off_rounded,
          accent: diagnosis.targetMet
              ? const Color(0xFF22C55E)
              : const Color(0xFFFF5B6A),
        ),
      ],
    );
  }

  Widget _buildRecommendationsCard() {
    return GlassCardDark(
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w700,
        color: Colors.white.withOpacity(0.80),
      ),
    );
  }

  Widget _statBox({
    required String title,
    required String value,
    required IconData icon,
    required Color accent,
  }) {
    return SizedBox(
      width: 160,
      child: _StatCard(
        title: title,
        value: value,
        icon: icon,
        accent: accent,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.55),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: accent.withOpacity(0.95),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent.withOpacity(0.95), size: 20),
          const SizedBox(height: 18),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}
