import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Displays a reusable animated glassmorphism button with a 3D press effect.
///
/// An [ElevatedButton3D] combines an entrance animation, translucent blurred
/// styling, and a pressed-state translation to create a tactile call-to-action
/// button.
class ElevatedButton3D extends StatefulWidget {
  /// Text displayed inside the button.
  final String label;

  /// Callback executed when the button is tapped.
  final VoidCallback onPressed;

  /// Optional icon displayed before the [label].
  final IconData? icon;

  /// Optional fixed width for the button.
  final double? width;

  /// Fixed height for the button.
  final double? height;

  /// Creates an animated 3D-style elevated button.
  const ElevatedButton3D({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 56,
  });

  @override
  State<ElevatedButton3D> createState() => _ElevatedButton3DState();
}

/// State responsible for handling the button press animation.
class _ElevatedButton3DState extends State<ElevatedButton3D> {
  /// Whether the button is currently being pressed.
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Entrance scale and fade animation.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final safeOpacity = value.clamp(0.0, 1.0).toDouble();

        return Transform.scale(
          scale: 0.5 + (0.5 * value),
          child: Opacity(opacity: safeOpacity, child: child),
        );
      },

      // Gesture layer used to update the pressed state.
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),

        // Animated container responsible for the 3D press movement.
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: Matrix4.identity()..translate(0.0, _isPressed ? 4.0 : 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),

            // Dynamic shadow depth changes according to the press state.
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 16),
                    ),
                  ],
          ),

          // Clip the blurred background to the rounded button shape.
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

              // Translucent gradient surface.
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.15),
                    ],
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      200,
                      227,
                      243,
                    ).withOpacity(0.9),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Material(
                  color: Colors.transparent,

                  // Centered button content.
                  child: Center(
                    child: widget.icon != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Optional leading icon.
                              Icon(widget.icon, color: Colors.white, size: 24),

                              const SizedBox(width: 10),

                              // Button label displayed after the icon.
                              Text(
                                widget.label,
                                style: GoogleFonts.archivo(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            widget.label,
                            style: GoogleFonts.archivo(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
