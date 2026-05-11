import 'backend_candidate.dart';

/// Defines the backend endpoint candidates available to the application.
///
/// Each [BackendCandidate] represents a possible execution environment for
/// the diagnosis pipeline, such as an embedded Jetson device or a desktop
/// workstation used during development and testing.
///
/// **HOW TO USE:**
/// 1. Copy this file to: `lib/src/external/config/api_config.dart`
/// 2. Update the backend URLs and names with your actual network addresses
/// 3. The original file is ignored by git for security reasons (.gitignore)
class ApiConfig {
  /// Ordered list of backend candidates used by the connection layer.
  ///
  /// The application can use this list to try different backend endpoints
  /// depending on availability, hardware platform, and expected processing
  /// latency.
  static const List<BackendCandidate> candidates = [
    BackendCandidate(
      name: 'Jetson Orin',
      baseUrl: 'http://your-jetson-orin-host.local:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),

    BackendCandidate(
      name: 'Jetson Nano',
      baseUrl: 'http://your-jetson-nano-host.local:8000',
      healthCheckTimeout: Duration(seconds: 15),
      diagnosisTimeout: Duration(seconds: 240),
      pollingIntervalSeconds: 5,
    ),

    BackendCandidate(
      name: 'Desktop Workstation',
      baseUrl: 'http://your-desktop-host.local:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),
  ];
}
