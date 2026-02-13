class SceneEvalConfig {
  final String apiEndpoint;
  final int timeoutSeconds;
  final double minConfidenceThreshold;
  final bool enableDebugMode;

  const SceneEvalConfig({
    required this.apiEndpoint,
    this.timeoutSeconds = 30,
    this.minConfidenceThreshold = 0.7,
    this.enableDebugMode = false,
  });

  factory SceneEvalConfig.development() {
    return const SceneEvalConfig(
      apiEndpoint: 'http://localhost:8080',
      enableDebugMode: true,
    );
  }

  factory SceneEvalConfig.production() {
    return const SceneEvalConfig(
      apiEndpoint: 'https://api.ar-sight.com',
      enableDebugMode: false,
    );
  }
}
