import '../../models/scene_diagnosis.dart';

class SceneDiagnosisAdapter {
  static SceneDiagnosis fromMap(Map<String, dynamic> map) {
    return SceneDiagnosis(
      status: map['status'] ?? 'unknown',
      riskLevel: map['risk_level'] ?? 'unknown',
      reason: map['reason'] ?? '',
      explanation: map['explanation'] ?? '',
      evidenceMetrics:
          List<String>.from(map['evidence_metrics'] ?? const []),
      recommendations:
          List<String>.from(map['recommendations'] ?? const []),
      sceneId: map['scene_id'] ?? 0,
      sceneName: map['scene_name'] ?? '',
      processingTime: map['processing_time'] ?? '',
    );
  }
}
