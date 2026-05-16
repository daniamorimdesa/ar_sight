import 'dart:ui';
import 'package:flutter/material.dart';

/// Displays a reusable glassmorphism-style dialog container.
///
/// A [DialogBox] wraps arbitrary [child] content inside a blurred translucent
/// container. It can optionally animate its entrance using a scale, opacity,
/// and vertical translation effect.
class DialogBox extends StatelessWidget {
  /// Content displayed inside the dialog box.
  final Widget child;

  /// Optional internal spacing applied around the [child].
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width for the dialog box.
  final double? width;

  /// Optional fixed height for the dialog box.
  final double? height;

  /// Whether the dialog box should animate when it appears.
  final bool animated;

  /// Creates a reusable glassmorphism dialog container.
  const DialogBox({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    // Base glassmorphism container.
    final box = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      // Clip the blur effect to match the rounded dialog shape.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

          // Translucent gradient layer behind the child content.
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 37, 37, 38).withOpacity(0.8),
                  const Color.fromARGB(255, 38, 39, 39).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (!animated) return box;

    // Entrance animation for the dialog box.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeOpacity = value.clamp(0.0, 1.0).toDouble();

        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: safeOpacity,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
      child: box,
    );
  }
}
