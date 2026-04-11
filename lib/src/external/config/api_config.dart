// api_config.dart
import 'backend_candidate.dart';

class ApiConfig {
  static const List<BackendCandidate> candidates = [
    BackendCandidate(
      name: 'Jetson Orin',
      baseUrl: 'http://farmaciaback.local:8000',
    ),
    BackendCandidate(
      name: 'Legion',
      baseUrl: 'http://pc062.local:8000',
    ),
  ];
}