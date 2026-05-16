import 'backend_candidate.dart';

/// Stores the currently selected backend for the application session.
///
/// A [BackendSession] keeps the active [BackendCandidate] resolved at runtime
/// and exposes convenient accessors for its connection and timeout settings.
/// If no backend has been selected, the accessors throw an [Exception] to avoid
/// using an invalid connection state.
class BackendSession {
  /// Backend candidate currently selected for the session.
  BackendCandidate? active;

  /// Base URL of the active backend.
  ///
  /// Throws an [Exception] if no backend has been selected.
  String get baseUrl {
    if (active == null) {
      throw Exception('No backend resolved');
    }
    return active!.baseUrl;
  }

  /// Human-readable name of the active backend.
  ///
  /// Returns `Unknown` when no backend has been selected.
  String get activeName => active?.name ?? 'Unknown';

  /// Health check timeout configured for the active backend.
  ///
  /// Throws an [Exception] if no backend has been selected.
  Duration get healthCheckTimeout {
    if (active == null) throw Exception('No backend selected');
    return active!.healthCheckTimeout;
  }

  /// Diagnosis timeout configured for the active backend.
  ///
  /// Throws an [Exception] if no backend has been selected.
  Duration get diagnosisTimeout {
    if (active == null) throw Exception('No backend selected');
    return active!.diagnosisTimeout;
  }

  /// Polling interval configured for the active backend, in seconds.
  ///
  /// Throws an [Exception] if no backend has been selected.
  int get pollingIntervalSeconds {
    if (active == null) throw Exception('No backend selected');
    return active!.pollingIntervalSeconds;
  }
}
