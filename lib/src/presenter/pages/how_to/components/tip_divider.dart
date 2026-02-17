import 'package:flutter/material.dart';

class TipDivider extends StatelessWidget {
  const TipDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Color(0xFFE5E7EB), height: 1),
    );
  }
}
