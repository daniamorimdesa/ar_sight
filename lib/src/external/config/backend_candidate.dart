/// Represents a backend endpoint that can be used by the application.
///
/// A [BackendCandidate] stores the connection information and timeout
/// parameters required to communicate with one execution environment of the
/// diagnosis pipeline, such as a Jetson device or a desktop workstation.
class BackendCandidate {
  /// Human-readable name used to identify the backend environment in the UI.
  final String name;

  /// Base URL used to send requests to the backend API.
  ///
  /// This value should include the protocol, host, and port, for example:
  /// `http://example-host.local:8000`.
  final String baseUrl;

  /// Maximum time allowed for backend health check requests.
  final Duration healthCheckTimeout;

  /// Maximum time allowed for diagnosis requests.
  ///
  /// This timeout may be longer for constrained embedded platforms that
  /// require more time to process a batch of frames.
  final Duration diagnosisTimeout;

  /// Interval, in seconds, between repeated backend status checks.
  final int pollingIntervalSeconds;

  /// Creates a backend candidate with connection and timeout parameters.
  const BackendCandidate({
    required this.name,
    required this.baseUrl,
    this.healthCheckTimeout = const Duration(seconds: 5),
    this.diagnosisTimeout = const Duration(seconds: 30),
    this.pollingIntervalSeconds = 2,
  });
}