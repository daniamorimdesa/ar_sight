import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays the backend processing state during scene diagnosis.
///
/// A [ProcessingState] adapts its icon, message, accent color, and loading
/// indicator according to the current diagnosis [status].
class ProcessingState extends StatelessWidget {
  /// Current backend diagnosis status.
  ///
  /// Expected values include `uploaded`, `upload_failed`, `processing`,
  /// `completed`, `failed`, or another backend-defined status.
  final String status;

  /// Creates a processing state widget for the provided [status].
  const ProcessingState({super.key, required this.status});

  /// Accent color associated with the current [status].
  Color get accent {
    switch (status) {
      case 'uploaded':
        return const Color(0xFF38BDF8);
      case 'processing':
        return const Color(0xFF8B5CF6);
      case 'completed':
        return const Color(0xFF22C55E);
      case 'failed':
      case 'upload_failed':
        return const Color(0xFFFF5B6A);
      default:
        return const Color(0xFF00D4FF);
    }
  }

  /// User-facing message associated with the current [status].
  String get message {
    switch (status) {
      case 'uploaded':
        return 'Upload complete';
      case 'processing':
        return 'Analyzing your scene...';
      case 'completed':
        return 'Diagnosis ready';
      case 'upload_failed':
        return 'Upload failed';
      case 'failed':
        return 'Analysis failed';
      default:
        return 'Preparing...';
    }
  }

  /// Whether the loading indicator should be displayed.
  bool get showLoader => status == 'processing';

  /// Whether the animated cat image should be displayed.
  bool get showCat => status == 'processing';

  /// Icon associated with non-processing states.
  IconData get icon {
    switch (status) {
      case 'uploaded':
        return Icons.cloud_done_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'failed':
      case 'upload_failed':
        return Icons.error_rounded;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated visual indicator for the current processing status.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: showCat
              ? TweenAnimationBuilder<double>(
                  key: const ValueKey('cat'),
                  tween: Tween(begin: 0.96, end: 1.04),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Image.asset(
                    'assets/icon/icon3_rm_bg.png',
                    width: 84,
                    height: 84,
                  ),
                )
              : Icon(
                  icon,
                  key: ValueKey('icon_$status'),
                  color: accent,
                  size: 54,
                ),
        ),

        const SizedBox(height: 14),

        // Status message shown below the visual indicator.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            message,
            key: ValueKey(message),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: status == 'completed'
                  ? accent
                  : Colors.white.withOpacity(0.92),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Loading spinner shown only while diagnosis processing is active.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: showLoader
              ? SizedBox(
                  key: const ValueKey('loader'),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                )
              : const SizedBox(key: ValueKey('no-loader'), height: 30),
        ),
      ],
    );
  }
}
