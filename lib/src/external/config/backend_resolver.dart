// backend_resolver.dart
import 'package:dio/dio.dart';

import 'api_config.dart';
import 'backend_candidate.dart';

class BackendResolver {
  final Dio dio;

  BackendResolver(this.dio);

  Future<BackendCandidate> resolve() async {
    for (final candidate in ApiConfig.candidates) {
      try {
        final response = await dio.get(
          '${candidate.baseUrl}/health',
          options: Options(
            sendTimeout: const Duration(seconds: 2),
            receiveTimeout: const Duration(seconds: 2),
          ),
        );

        if (response.statusCode == 200) {
          return candidate;
        }
      } catch (_) {
        // tenta o próximo
      }
    }

    throw Exception('No backend available on the network.');
  }
}