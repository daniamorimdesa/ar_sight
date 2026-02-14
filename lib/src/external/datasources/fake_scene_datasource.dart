import 'dart:math';
import 'dart:typed_data';
import 'scene_datasource.dart';

class FakeSceneDatasource implements SceneDatasource {
  final Random _random = Random();

  @override
  Future<List<Map<String, dynamic>>> evaluateScene(
    List<Uint8List> frames,
  ) async {
    // Simula latência do backend
    await Future.delayed(
      Duration(seconds: 2 + _random.nextInt(4)),
    );

    return [
      {
        "status": _random.nextBool() ? "pass" : "fail",
        "risk_level": "medium",
        "reason": "Mock evaluation",
        "explanation":
            "This is a simulated backend response used for UI testing.",
        "evidence_metrics": ["illumination", "occlusion_level"],
        "recommendations": [
          "Adjust lighting",
          "Reduce occlusion"
        ],
        "scene_id": 1,
        "scene_name": "Mock Scene",
        "processing_time": "3.2s"
      }
    ];
  }
}
