// api_config.dart
import 'backend_candidate.dart';

class ApiConfig {
  static const List<BackendCandidate> candidates = [
    // Jetson Orin AGX - Processador rápido
    BackendCandidate(
      name: 'Jetson Orin',
      baseUrl: 'http://farmaciaback.local:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),

    // Jetson Nano - Processador lento (~3 minutos)
    BackendCandidate(
      name: 'Jetson Nano',
      baseUrl: 'http://jetson-nano.local:8000',
      healthCheckTimeout: Duration(seconds: 15),
      diagnosisTimeout: Duration(seconds: 240), // 4 minutos para cobrir 3 min de processamento
      pollingIntervalSeconds: 5,
    ),

    // PC Legion - Desktop rápido
    BackendCandidate(
      name: 'Legion',
      // baseUrl: 'http://pc062.local:8000',
      baseUrl: 'http://192.168.155.163:8000',
      healthCheckTimeout: Duration(seconds: 5),
      diagnosisTimeout: Duration(seconds: 30),
      pollingIntervalSeconds: 1,
    ),
  ];
}