import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;
  final IconData? icon;
  final Color? iconColor;
  final Color? labelColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor ?? accent, size: 20),
          const SizedBox(width: 10),
        ],
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: labelColor ?? Colors.white.withOpacity(0.75),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: accent.withOpacity(0.95),
            ),
          ),
        ),
      ],
    );
  }
}
