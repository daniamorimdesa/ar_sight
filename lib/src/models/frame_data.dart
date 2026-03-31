// frame_data.dart: modelo para estruturar os dados de um frame individual

class FrameData {
  final int index;
  final String status; // "pass" ou "fail"
  final String riskLevel; // "low", "high", etc
  final String explanation;
  final List<String> recommendations;
  final String filename;
  final Map<String, dynamic> metrics;

  FrameData({
    required this.index,
    required this.status,
    required this.riskLevel,
    required this.explanation,
    required this.recommendations,
    required this.filename,
    required this.metrics,
  });

  // Factory para criar a partir do mapa do backend
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

  // Getters úteis
  bool get isPass => status == 'pass';
  String get illuminationLabel => (metrics['illumination_label'] ?? 'unknown').toString();
  double get illuminationScore => (metrics['illumination_score'] ?? 0.0) as double;
  double get meanBrightness => (metrics['mean_brightness'] ?? 0.0) as double;
  double get uniformity => (metrics['uniformity'] ?? 0.0) as double;
}
