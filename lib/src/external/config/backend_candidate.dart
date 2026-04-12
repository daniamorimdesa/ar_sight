// backend_candidate.dart
class BackendCandidate {
  final String name;
  final String baseUrl;
  final Duration healthCheckTimeout; // Timeout para verificação de saúde do backend
  final Duration diagnosisTimeout;   // Timeout para operações de diagnóstico (mais longos para Jetson Nano)
  final int pollingIntervalSeconds;  // Intervalo entre verificações de status

  const BackendCandidate({
    required this.name,
    required this.baseUrl,
    this.healthCheckTimeout = const Duration(seconds: 5),
    this.diagnosisTimeout = const Duration(seconds: 30),
    this.pollingIntervalSeconds = 2,
  });
}