// backend_session.dart
import 'backend_candidate.dart';

class BackendSession {
  BackendCandidate? active;

  String get baseUrl {
    if (active == null) {
      throw Exception('No backend resolved');
    }
    return active!.baseUrl;
  }

  String get activeName => active?.name ?? 'Unknown';

  Duration get healthCheckTimeout {
    if (active == null) throw Exception('No backend selected');
    return active!.healthCheckTimeout;
  }

  Duration get diagnosisTimeout {
    if (active == null) throw Exception('No backend selected');
    return active!.diagnosisTimeout;
  }

  int get pollingIntervalSeconds {
    if (active == null) throw Exception('No backend selected');
    return active!.pollingIntervalSeconds;
  }
}