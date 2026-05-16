import 'recommendation_group.dart';

/// Represents the complete diagnosis result for a captured scene.
///
/// A [SceneDiagnosis] stores the structured output produced after processing
/// a batch of frames. It includes the final classification, risk level,
/// explanation, recommendations, execution metadata, performance metrics,
/// validation statistics, aggregated image metrics, and frame-level results.
class SceneDiagnosis {
  /// Final diagnosis status assigned to the scene.
  ///
  /// Expected values include `pass` and `fail`.
  final String status;

  /// Overall risk level assigned to the scene.
  ///
  /// Expected values include `low`, `medium`, `high`, or backend-defined risk
  /// labels.
  final String riskLevel;

  /// Most frequent or most relevant diagnosis label detected in the batch.
  final String dominantLabel;

  /// Natural language explanation describing the diagnosis result.
  final String explanation;

  /// Flat list of recommendations returned by the backend.
  final List<String> recommendations;

  /// Recommendations grouped by condition and affected frames.
  final List<RecommendationGroup> recommendationGroups;

  /// Number of frames classified as normal or acceptable.
  final int normalCount;

  /// Number of frames classified as problematic.
  final int problemCount;

  /// Human-readable processing time displayed by the UI.
  final String processingTime;

  /// Execution environment where the backend pipeline was evaluated.
  final String environment;

  /// Language model used to generate the diagnosis explanation.
  final String model;

  /// Hardware device or platform used by the backend.
  final String device;

  /// Quantization mode used by the backend model, when available.
  final String quantization;

  /// Number of frames processed in the diagnosis batch.
  final int batchSize;

  /// Total time spent on deterministic image processing, in milliseconds.
  final double pdiTotalMs;

  /// Average deterministic image processing time per frame, in milliseconds.
  final double pdiPerImageMs;

  /// Total time spent on language model inference, in seconds.
  final double slmTotalS;

  /// Average language model inference time per diagnosis, in seconds.
  final double slmPerDiagnosisS;

  /// Total end-to-end diagnosis time, in seconds.
  final double totalS;

  /// Whether the backend processing time met the target latency constraint.
  final bool targetMet;

  /// Total number of frames evaluated in the batch.
  final int totalFrames;

  /// Number of frames classified correctly during validation.
  final int correctFrames;

  /// Validation accuracy reported by the backend.
  final double accuracy;

  /// Aggregated metric values computed across the frame batch.
  ///
  /// This map may include values such as average luminance, brightness,
  /// uniformity, and clipping percentages.
  final Map<String, dynamic> metricsAvg;

  /// Raw frame-level diagnosis results returned by the backend.
  final List<Map<String, dynamic>> frames;

  /// Creates a complete scene diagnosis result.
  SceneDiagnosis({
    required this.status,
    required this.riskLevel,
    required this.dominantLabel,
    required this.explanation,
    required this.recommendations,
    required this.recommendationGroups,
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
