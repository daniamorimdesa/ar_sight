import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  final VoidCallback onInstructionsTap;
  final VoidCallback onLastFramesTap;
  final VoidCallback onLastDiagnosisTap;

  // NOVO:
  final bool hasFrames;
  final String? lastStatus; // "pass" | "fail" | null

  const HomeBottomBar({
    super.key,
    required this.onInstructionsTap,
    required this.onLastFramesTap,
    required this.onLastDiagnosisTap,
    required this.hasFrames,
    required this.lastStatus,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiagnosis = lastStatus != null;
    final isPass = lastStatus == 'pass';
    final diagColor = isPass ? Colors.greenAccent : Colors.redAccent;

    return Container(
      height: 80,
      color: const Color.fromARGB(255, 0, 0, 0),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomBarButton(
              icon: Icons.help_outline_rounded,
              onTap: onInstructionsTap,
            ),

            _BottomBarButton(
              icon: hasFrames ? Icons.photo_library : Icons.photo_library_outlined,
              onTap: onLastFramesTap,
              badgeColor: hasFrames ? Colors.cyanAccent : null,
            ),

            _BottomBarButton(
              icon: hasDiagnosis
                  ? (isPass ? Icons.verified : Icons.error)
                  : Icons.analytics_outlined,
              onTap: onLastDiagnosisTap,
              badgeColor: hasDiagnosis ? diagColor : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  // NOVO:
  final Color? badgeColor;

  const _BottomBarButton({
    required this.icon,
    required this.onTap,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: const Color.fromARGB(255, 211, 235, 243),
            size: 28,
          ),
          iconSize: 28,
        ),

        if (badgeColor != null)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: badgeColor!.withOpacity(0.45),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
