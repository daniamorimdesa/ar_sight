import 'package:flutter/material.dart';
import 'scene_eval_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'Hold the phone with both hands (or use a grip) to reduce shake.',
      'Point the camera to the area where AR will run (floor/target region).',
      'Start a slow scan for 10 seconds (smooth movement, no quick turns).',
      'Try to keep lighting stable and avoid strong reflections when possible.',
      'If someone crosses the scene or you shake the phone, restart the scan.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AR_Sight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scene Evaluation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'A quick 10-second scan to check if the environment is suitable for stable AR tracking.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Before you start',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ...items.map(
                      (t) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•  ', style: TextStyle(fontSize: 16)),
                            Expanded(child: Text(t)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            FilledButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SceneEvalPage()),
                );
              },
              child: const Text('Start scene evaluation'),
            ),
            const SizedBox(height: 8),
            Text(
              'Tip: move slowly and smoothly (ARCore-style scan).',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
