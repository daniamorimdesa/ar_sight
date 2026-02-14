class SceneDiagnosis {
  final String status;       // pass / fail
  final String riskLevel;    // low / medium / high
  final String reason;
  final String explanation;
  final List<String> evidenceMetrics;
  final List<String> recommendations;
  final int sceneId;
  final String sceneName;
  final String processingTime;

  SceneDiagnosis({
    required this.status,
    required this.riskLevel,
    required this.reason,
    required this.explanation,
    required this.evidenceMetrics,
    required this.recommendations,
    required this.sceneId,
    required this.sceneName,
    required this.processingTime,
  });
}
