import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final Widget child;

  const GlassBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.50),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: child,
    );
  }
}
