import 'package:flutter/material.dart';
import '../../models/scene_diagnosis.dart';

class ResultPage extends StatelessWidget {
  final SceneDiagnosis diagnosis;

  const ResultPage({super.key, required this.diagnosis});

  Color get _statusColor =>
      diagnosis.status == 'pass' ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scene Evaluation Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      diagnosis.sceneName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            diagnosis.status.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _statusColor,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            'Risk: ${diagnosis.riskLevel}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      diagnosis.reason,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(diagnosis.explanation),
                    const SizedBox(height: 12),
                    Text(
                      'Processing time: ${diagnosis.processingTime}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (diagnosis.evidenceMetrics.isNotEmpty) ...[
              const Text(
                'Evidence metrics',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: diagnosis.evidenceMetrics
                    .map((e) => Chip(label: Text(e)))
                    .toList(),
              ),
            ],

            const SizedBox(height: 16),

            if (diagnosis.recommendations.isNotEmpty) ...[
              const Text(
                'Recommendations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...diagnosis.recommendations.map(
                (r) => ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: Text(r),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
