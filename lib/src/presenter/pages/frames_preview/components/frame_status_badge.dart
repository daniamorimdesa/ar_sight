import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrameStatusBadge extends StatelessWidget {
  final bool isPass;
  final double top;
  final double right;

  const FrameStatusBadge({
    super.key,
    required this.isPass,
    this.top = 8,
    this.right = 8,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isPass ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B);
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
