import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final Color accent;
  final bool isPass;

  const StatusIcon({super.key, required this.accent, required this.isPass});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withOpacity(0.10),
        border: Border.all(color: accent.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.14),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        isPass ? Icons.task_alt_rounded : Icons.tips_and_updates_outlined,
        color: accent,
        size: 28,
      ),
    );
  }
}
