import 'package:flutter/material.dart';

class DiagnosisCard extends StatelessWidget {
  final String title;
  final String description;
  final double? confidence;
  
  const DiagnosisCard({
    super.key,
    required this.title,
    required this.description,
    this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(description),
            if (confidence != null) ...[
              const SizedBox(height: 8),
              Text('Confidence: ${(confidence! * 100).toStringAsFixed(1)}%'),
            ],
          ],
        ),
      ),
    );
  }
}
