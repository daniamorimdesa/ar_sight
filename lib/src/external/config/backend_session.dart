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
}