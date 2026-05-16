import 'dart:math';
import 'scene_datasource.dart';

/// Fake implementation of [SceneDatasource] used for UI development and tests.
///
/// This datasource simulates the backend diagnosis workflow without requiring
/// a real API connection. It provides mock responses for starting a diagnosis,
/// polling its status, and retrieving the final scene diagnosis result.
class FakeSceneDatasource implements SceneDatasource {
  /// Random generator used to produce varied mock diagnosis results.
  final Random _random = Random();

  /// Stores the simulated processing status for each batch identifier.
  final Map<String, String> _status = {};

  /// Stores the number of status polls performed for each batch identifier.
  final Map<String, int> _pollCount = {};

  /// Starts a mock diagnosis process for the provided [batchId].
  ///
  /// The method simulates a short startup delay and marks the batch as
  /// `processing`.
  @override
  Future<Map<String, dynamic>> startDiagnosis(String batchId) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    _status[batchId] = 'processing';
    _pollCount[batchId] = 0;

    return {'batch_id': batchId, 'status': 'processing'};
  }

  /// Returns the simulated diagnosis status for the provided [batchId].
  ///
  /// The first polls return `processing`, and the status is changed to
  /// `completed` after enough polling attempts. This behavior helps validate
  /// UI loading and polling states during development.
  @override
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId) async {
    // Simulate request latency so that loading transitions are visible.
    await Future.delayed(const Duration(milliseconds: 1200));

    _pollCount[batchId] = (_pollCount[batchId] ?? 0) + 1;
    final pollCount = _pollCount[batchId]!;

    _status[batchId] = pollCount >= 3 ? 'completed' : 'processing';

    return {'batch_id': batchId, 'status': _status[batchId]};
  }

  /// Returns a mock diagnosis result for the provided [batchId].
  ///
  /// The generated response follows the same structure expected from the real
  /// backend, including metadata, performance metrics, statistics, summary
  /// information, recommendations, and frame-level metrics.
  @override
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final isGood = _random.nextBool();

    final pdiTotalMs = isGood
        ? _random.nextDouble() * 200 + 300
        : _random.nextDouble() * 400 + 500;

    final pdiPerImageMs = pdiTotalMs / 10;

    final slmTotalS = isGood
        ? _random.nextDouble() + 1
        : _random.nextDouble() * 2 + 2;

    final slmPerDiagnosisS = slmTotalS / 10;
    final totalS = pdiTotalMs / 1000 + slmTotalS;

    final correctFrames = isGood
        ? 9 + _random.nextInt(2)
        : 4 + _random.nextInt(3);
    final totalFrames = 10;
    final accuracy = (correctFrames / totalFrames) * 100;

    final List<Map<String, dynamic>> framesList = [];

    for (int i = 0; i < totalFrames; i++) {
      framesList.add({
        'frame_id': i,
        'mean_luma': isGood
            ? 100 + _random.nextInt(30)
            : 40 + _random.nextInt(30),
        'uniformity': isGood
            ? 0.65 + _random.nextDouble() * 0.25
            : 0.3 + _random.nextDouble() * 0.25,
        'score': isGood
            ? 0.8 + _random.nextDouble() * 0.2
            : 0.4 + _random.nextDouble() * 0.3,
        'status': (isGood || i < correctFrames) ? 'good' : 'poor',
      });
    }

    return {
      'metadata': {
        'environment': 'mobile_app',
        'model': 'ar_scene_model_v2',
        'device': 'flutter_simulator',
        'quantization': 'fp32',
        'batch_size': 10,
      },
      'performance': {
        'pdi_total_ms': pdiTotalMs,
        'pdi_per_image_ms': pdiPerImageMs,
        'slm_total_s': slmTotalS,
        'slm_per_diagnosis_s': slmPerDiagnosisS,
        'total_s': totalS,
        'target_met': isGood,
      },
      'statistics': {
        'total': totalFrames,
        'correct': correctFrames,
        'accuracy': accuracy,
      },
      'summary': {
        'overall_risk': isGood ? 'low' : 'high',
        'dominant_label': isGood ? 'adequate' : 'underexposed',
        'problem_count': isGood ? 0 : (10 - correctFrames),
        'normal_count': isGood ? 10 : correctFrames,
        'explanation': isGood
            ? 'Lighting conditions are ideal for AR. Contrast is sufficient and scene features are well-defined.'
            : 'Scene presents lighting issues affecting AR tracking. Low luminance and poor uniformity detected.',
        'recommendations': [
          {
            'condition': isGood ? 'adequate' : 'underexposed',
            'count': isGood ? 10 : (10 - correctFrames),
            'actions': isGood
                ? [
                    'Maintain current lighting conditions',
                    'Scene is ready for AR experience',
                    'Features are well-tracked',
                  ]
                : [
                    'Increase ambient lighting significantly',
                    'Avoid deep shadows and dark corners',
                    'Use indirect natural light when possible',
                    'Consider moving to a brighter location',
                  ],
          },
        ],
        'metrics_avg': {
          'mean_luma': isGood
              ? 100 + _random.nextDouble() * 30
              : 40 + _random.nextDouble() * 30,
          'uniformity': isGood
              ? 0.65 + _random.nextDouble() * 0.3
              : 0.3 + _random.nextDouble() * 0.25,
          'mean_brightness': isGood
              ? 0.5 + _random.nextDouble() * 0.4
              : 0.1 + _random.nextDouble() * 0.3,
          'pct_clipped_bright': _random.nextDouble() * 0.01,
          'pct_clipped_dark': _random.nextDouble() * 0.005,
        },
      },
      'frames': framesList,
    };
  }
}
