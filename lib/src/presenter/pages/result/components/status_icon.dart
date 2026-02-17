import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final Color accent;
  final bool isPass;

  const StatusIcon({super.key, required this.accent, required this.isPass});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isPass ? Icons.check_rounded : Icons.priority_high_rounded,
        color: Colors.white.withOpacity(0.92),
        size: 28,
      ),
    );
  }
}
