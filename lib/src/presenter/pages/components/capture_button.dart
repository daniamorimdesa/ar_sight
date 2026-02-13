import 'package:flutter/material.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const CaptureButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.camera_alt),
    );
  }
}
