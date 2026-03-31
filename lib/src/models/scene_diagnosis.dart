// scene_diagnosis.dart: modelo de dados para representar o diagnóstico de uma cena, incluindo status, nível de risco, razões, explicações, métricas de evidência, recomendações e informações da cena

class SceneDiagnosis {
  final String status;
  final String riskLevel;
  final String dominantLabel;
  final String explanation;
  final List<String> recommendations;

  final int normalCount;
  final int problemCount;

  final String processingTime;

  final String environment;
  final String model;
  final String device;
  final String quantization;
  final int batchSize;

  final double pdiTotalMs;
  final double pdiPerImageMs;
  final double slmTotalS;
  final double slmPerDiagnosisS;
  final double totalS;
  final bool targetMet;

  final int totalFrames;
  final int correctFrames;
  final double accuracy;

  final Map<String, dynamic> metricsAvg;
  final List<Map<String, dynamic>> frames;

  SceneDiagnosis({
    required this.status,
    required this.riskLevel,
    required this.dominantLabel,
    required this.explanation,
    required this.recommendations,
    required this.normalCount,
    required this.problemCount,
    required this.processingTime,
    required this.environment,
    required this.model,
    required this.device,
    required this.quantization,
    required this.batchSize,
    required this.pdiTotalMs,
    required this.pdiPerImageMs,
    required this.slmTotalS,
    required this.slmPerDiagnosisS,
    required this.totalS,
    required this.targetMet,
    required this.totalFrames,
    required this.correctFrames,
    required this.accuracy,
    required this.metricsAvg,
    required this.frames,
  });
}
