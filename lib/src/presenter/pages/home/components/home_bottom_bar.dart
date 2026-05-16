import 'package:flutter/material.dart';

/// Displays the bottom navigation bar used on the home page.
///
/// A [HomeBottomBar] provides quick access to the instructions screen, the
/// latest captured frames, and the latest diagnosis result. Visual badges are
/// used to indicate whether frame data or diagnosis data is currently
/// available.
class HomeBottomBar extends StatelessWidget {
  /// Callback executed when the instructions button is tapped.
  final VoidCallback onInstructionsTap;

  /// Callback executed when the latest frames button is tapped.
  final VoidCallback onLastFramesTap;

  /// Callback executed when the latest diagnosis button is tapped.
  final VoidCallback onLastDiagnosisTap;

  /// Whether there are captured frames available from the latest evaluation.
  final bool hasFrames;

  /// Status of the latest diagnosis result.
  ///
  /// Expected values are `pass`, `fail`, or `null` when no diagnosis is
  /// available.
  final String? lastStatus;

  /// Creates the home page bottom navigation bar.
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
            // Opens the usage instructions page.
            _BottomBarButton(
              icon: Icons.help_outline_rounded,
              onTap: onInstructionsTap,
            ),

            // Opens the latest captured frames, when available.
            _BottomBarButton(
              icon: hasFrames
                  ? Icons.photo_library
                  : Icons.photo_library_outlined,
              onTap: onLastFramesTap,
              badgeColor: hasFrames ? Colors.cyanAccent : null,
            ),

            // Opens the latest diagnosis result, when available.
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

/// Internal icon button used by [HomeBottomBar].
///
/// The button can optionally display a small colored badge to indicate that
/// related data is available.
class _BottomBarButton extends StatelessWidget {
  /// Icon displayed by the button.
  final IconData icon;

  /// Callback executed when the button is tapped.
  final VoidCallback onTap;

  /// Optional color used for the availability/status badge.
  final Color? badgeColor;

  /// Creates a bottom bar icon button.
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
        // Main navigation icon.
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: const Color.fromARGB(255, 211, 235, 243),
            size: 28,
          ),
          iconSize: 28,
        ),

        // Optional availability/status badge.
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
