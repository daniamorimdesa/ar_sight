import 'package:dio/dio.dart';
import 'api_config.dart';
import 'backend_candidate.dart';

/// Resolves the first available backend from the configured candidates.
///
/// The resolver iterates through the candidates defined in [ApiConfig] and
/// sends a health check request to each backend. The first candidate that
/// responds successfully is selected as the active backend for the application.
class BackendResolver {
  /// HTTP client used to perform backend health check requests.
  final Dio dio;

  /// Creates a resolver using the provided [dio] client.
  BackendResolver(this.dio);

  /// Returns the first backend candidate available on the network.
  ///
  /// Each configured [BackendCandidate] is checked through its `/health`
  /// endpoint. If no backend responds successfully, an [Exception] is thrown.
  Future<BackendCandidate> resolve() async {
    for (final candidate in ApiConfig.candidates) {
      try {
        final response = await dio.get(
          '${candidate.baseUrl}/health',
          options: Options(
            sendTimeout: candidate.healthCheckTimeout,
            receiveTimeout: candidate.healthCheckTimeout,
          ),
        );

        if (response.statusCode == 200) {
          return candidate;
        }
      } catch (_) {
        // Ignore unavailable candidates and try the next configured backend.
      }
    }

    throw Exception('No backend available on the network.');
  }
}
