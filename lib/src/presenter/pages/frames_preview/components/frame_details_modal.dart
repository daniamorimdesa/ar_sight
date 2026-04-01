import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/frame_data.dart';
import 'metric_row.dart';

class FrameDetailsModal extends StatelessWidget {
  final FrameData frameData;

  const FrameDetailsModal({
    super.key,
    required this.frameData,
  });

  @override
  Widget build(BuildContext context) {
    final isPass = frameData.isPass;
    final statusColor = isPass ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: const Color(0xFF1a1a2e),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildModalHeader(statusColor),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Explanation
                    _buildExplanation(),

                    const SizedBox(height: 20),

                    // Metrics Section
                    _buildMetricsSection(),

                    const SizedBox(height: 20),

                    // Recommendations Section
                    if (frameData.recommendations.isNotEmpty)
                      _buildRecommendationsSection(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon/icon3_rm_bg.png',
            height: 72,
            width: 72,
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              'Frame Details',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            child: Text(
              frameData.isPass ? 'PASS' : 'FAIL',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),            ),          ),
        ],
      ),
    );
  }

  Widget _buildExplanation() {
    return Text(
      frameData.explanation,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        height: 1.6,
        color: Colors.white.withOpacity(0.88),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ILLUMINATION METRICS',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.60),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        MetricRow(
          label: 'Label',
          value: frameData.illuminationLabel.toUpperCase(),
          color: const Color(0xFF38BDF8),
        ),
        MetricRow(
          label: 'Score',
          value: '${(frameData.illuminationScore * 100).toStringAsFixed(1)}%',
          color: const Color(0xFF06B6D4),
        ),
        MetricRow(
          label: 'Brightness',
          value: '${(frameData.meanBrightness * 255).toStringAsFixed(0)}/255',
          color: const Color(0xFFA78BFA),
        ),
        MetricRow(
          label: 'Uniformity',
          value: frameData.uniformity.toStringAsFixed(3),
          color: const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDATIONS',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.60),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        ...frameData.recommendations.map(
          (rec) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.70),
                  ),
                ),
                Expanded(
                  child: Text(
                    rec,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white.withOpacity(0.80),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
