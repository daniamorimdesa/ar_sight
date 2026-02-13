class Diagnosis {
  final String id;
  final String result;
  final double confidence;
  final DateTime timestamp;

  Diagnosis({
    required this.id,
    required this.result,
    required this.confidence,
    required this.timestamp,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'] as String,
      result: json['result'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
