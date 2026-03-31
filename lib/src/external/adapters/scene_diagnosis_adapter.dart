// scene_diagnosis_adapter.dart: adaptador para converter a resposta bruta do backend em um objeto SceneDiagnosis estruturado
import '../../models/scene_diagnosis.dart';

class SceneDiagnosisAdapter {
  static SceneDiagnosis fromBackend(Map<String, dynamic> map) {
    final metadata = Map<String, dynamic>.from(map['metadata'] ?? {});
    final performance = Map<String, dynamic>.from(map['performance'] ?? {});
    final statistics = Map<String, dynamic>.from(map['statistics'] ?? {});
    final summary = Map<String, dynamic>.from(map['summary'] ?? {});
    final frames = List<Map<String, dynamic>>.from(
      (map['frames'] ?? []).map((e) => Map<String, dynamic>.from(e)),
    );

    final overallRisk = (summary['overall_risk'] ?? 'unknown').toString();
    final dominantLabel = (summary['dominant_label'] ?? 'unknown').toString();
    final explanation = (summary['explanation'] ?? '').toString();

    final normalCount = summary['normal_count'] ?? 0;
    final problemCount = summary['problem_count'] ?? 0;

    final recommendationsRaw = summary['recommendations'] ?? [];
    final List<String> recommendations = [];
    for (final r in recommendationsRaw) {
      final actions = r['actions'] ?? [];
      recommendations.addAll(List<String>.from(actions));
    }

    final isPass = overallRisk.toLowerCase() == 'low';

    return SceneDiagnosis(
      status: isPass ? 'pass' : 'fail',
      riskLevel: overallRisk,
      dominantLabel: dominantLabel,
      explanation: explanation,
      recommendations: recommendations,
      normalCount: normalCount,
      problemCount: problemCount,
      processingTime: '${((performance['total_s'] ?? 0) as num).toStringAsFixed(2)}s',

      environment: (metadata['environment'] ?? '-').toString(),
      model: (metadata['model'] ?? '-').toString(),
      device: (metadata['device'] ?? '-').toString(),
      quantization: (metadata['quantization'] ?? '-').toString(),
      batchSize: metadata['batch_size'] ?? 0,

      pdiTotalMs: (performance['pdi_total_ms'] ?? 0).toDouble(),
      pdiPerImageMs: (performance['pdi_per_image_ms'] ?? 0).toDouble(),
      slmTotalS: (performance['slm_total_s'] ?? 0).toDouble(),
      slmPerDiagnosisS: (performance['slm_per_diagnosis_s'] ?? 0).toDouble(),
      totalS: (performance['total_s'] ?? 0).toDouble(),
      targetMet: performance['target_met'] ?? false,

      totalFrames: statistics['total'] ?? 0,
      correctFrames: statistics['correct'] ?? 0,
      accuracy: (statistics['accuracy'] ?? 0).toDouble(),

      metricsAvg: Map<String, dynamic>.from(summary['metrics_avg'] ?? {}),
      frames: frames,
    );
  }
}