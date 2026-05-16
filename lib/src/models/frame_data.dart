/// Represents the diagnosis data associated with a single captured frame.
///
/// A [FrameData] instance stores the classification result, risk level,
/// explanation, recommendations, filename, and raw metrics returned by the
/// backend for one frame in a diagnosis batch.
class FrameData {
  /// Position of the frame within the captured batch.
  final int index;

  /// Classification status assigned to the frame.
  ///
  /// Expected values include `pass`, `fail`, or `unknown`.
  final String status;

  /// Risk level assigned to the frame.
  ///
  /// Expected values include `low`, `medium`, `high`, or `unknown`.
  final String riskLevel;

  /// Natural language explanation generated for the frame diagnosis.
  final String explanation;

  /// Corrective actions or recommendations associated with this frame.
  final List<String> recommendations;

  /// Name of the frame file as stored or referenced by the backend.
  final String filename;

  /// Raw metric values extracted for this frame.
  ///
  /// This map may include values such as illumination score, brightness,
  /// uniformity, and illumination label.
  final Map<String, dynamic> metrics;

  /// Creates a frame diagnosis data object.
  FrameData({
    required this.index,
    required this.status,
    required this.riskLevel,
    required this.explanation,
    required this.recommendations,
    required this.filename,
    required this.metrics,
  });

  /// Creates a [FrameData] instance from a backend response [map].
  ///
  /// Missing fields are replaced with safe fallback values to keep the UI
  /// stable when optional frame-level data is unavailable.
  factory FrameData.fromBackend(Map<String, dynamic> map, int index) {
    return FrameData(
      index: index,
      status: (map['status'] ?? 'unknown').toString().toLowerCase(),
      riskLevel: (map['risk_level'] ?? 'unknown').toString().toLowerCase(),
      explanation: (map['explanation'] ?? '').toString(),
      recommendations: List<String>.from(map['recommendations'] ?? []),
      filename: (map['filename'] ?? 'frame_$index.jpg').toString(),
      metrics: Map<String, dynamic>.from(map['metrics'] ?? {}),
    );
  }

  /// Whether the frame was classified as suitable for the AR scene.
  bool get isPass => status == 'pass';

  /// Illumination label assigned to the frame.
  String get illuminationLabel {
    return (metrics['illumination_label'] ?? 'unknown').toString();
  }

  /// Normalized illumination score assigned to the frame.
  double get illuminationScore {
    return (metrics['illumination_score'] ?? 0.0).toDouble();
  }

  /// Mean brightness value extracted from the frame.
  double get meanBrightness {
    return (metrics['mean_brightness'] ?? 0.0).toDouble();
  }

  /// Uniformity value extracted from the frame.
  double get uniformity {
    return (metrics['uniformity'] ?? 0.0).toDouble();
  }
}
