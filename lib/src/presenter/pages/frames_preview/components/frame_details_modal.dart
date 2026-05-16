import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/frame_data.dart';
import 'metric_row.dart';

/// Displays detailed diagnosis information for a single frame.
///
/// A [FrameDetailsModal] presents the frame explanation, illumination metrics,
/// and optional recommendations in a bottom-sheet style layout.
class FrameDetailsModal extends StatelessWidget {
  /// Diagnosis data associated with the selected frame.
  final FrameData frameData;

  /// Creates a details modal for the provided [frameData].
  const FrameDetailsModal({super.key, required this.frameData});

  @override
  Widget build(BuildContext context) {
    final isPass = frameData.isPass;
    final statusColor = isPass
        ? const Color(0xFF38BDF8)
        : const Color(0xFFF59E0B);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: const Color(0xFF1a1a2e),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal header with title, icon, and status badge.
              _buildModalHeader(statusColor),

              // Main modal content.
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Frame-level diagnosis explanation.
                    _buildExplanation(),

                    const SizedBox(height: 20),

                    // Illumination metrics reported by the backend.
                    _buildMetricsSection(),

                    const SizedBox(height: 20),

                    // Corrective actions shown only when available.
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

  /// Builds the modal header with the app icon, title, and diagnosis status.
  Widget _buildModalHeader(Color statusColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.10)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Application icon displayed on the left side of the modal header.
          Image.asset('assets/icon/icon3_rm_bg.png', height: 72, width: 72),

          const SizedBox(width: 8),

          // Modal title.
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

          // PASS/FAIL status badge.
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the natural language explanation for the selected frame.
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

  /// Builds the illumination metrics section.
  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title.
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

        // Frame illumination classification label.
        MetricRow(
          label: 'Label',
          value: frameData.illuminationLabel.toUpperCase(),
          color: const Color(0xFF38BDF8),
        ),

        // Normalized illumination score.
        MetricRow(
          label: 'Score',
          value: '${(frameData.illuminationScore * 100).toStringAsFixed(1)}%',
          color: const Color(0xFF06B6D4),
        ),

        // Mean brightness mapped to an 8-bit pixel intensity scale.
        MetricRow(
          label: 'Brightness',
          value: '${(frameData.meanBrightness * 255).toStringAsFixed(0)}/255',
          color: const Color(0xFFA78BFA),
        ),

        // Spatial lighting uniformity value.
        MetricRow(
          label: 'Uniformity',
          value: frameData.uniformity.toStringAsFixed(3),
          color: const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  /// Builds the recommendation list for the selected frame.
  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title.
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

        // Bullet list of corrective actions.
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
