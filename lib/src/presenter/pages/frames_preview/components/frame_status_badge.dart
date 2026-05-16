import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a positioned PASS/FAIL status badge for a frame.
///
/// A [FrameStatusBadge] is designed to be used inside a [Stack], typically
/// over a frame preview image. The badge color and label are determined by
/// the [isPass] value.
class FrameStatusBadge extends StatelessWidget {
  /// Whether the associated frame passed the diagnosis criteria.
  final bool isPass;

  /// Distance from the top edge of the parent [Stack].
  final double top;

  /// Distance from the right edge of the parent [Stack].
  final double right;

  /// Creates a positioned frame status badge.
  const FrameStatusBadge({
    super.key,
    required this.isPass,
    this.top = 8,
    this.right = 8,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isPass
        ? const Color(0xFF38BDF8)
        : const Color(0xFFF59E0B);
    final statusLabel = isPass ? 'PASS' : 'FAIL';

    return Positioned(
      top: top,
      right: right,
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

        // User-facing diagnosis status label.
        child: Text(
          statusLabel,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
