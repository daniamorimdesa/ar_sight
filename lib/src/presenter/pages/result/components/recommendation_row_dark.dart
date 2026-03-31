import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationRowDark extends StatelessWidget {
  final int index;
  final String text;
  final Color accent;

  const RecommendationRowDark({
    super.key,
    required this.index,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, // Circle diameter
            height: 36, // Circle diameter
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent,
             
            ),
            child: Text(
              '$index',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.78),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
