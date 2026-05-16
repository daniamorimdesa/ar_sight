import 'package:dio/dio.dart';
import '../config/backend_session.dart';

/// Defines the contract for scene diagnosis data sources.
///
/// A [SceneDatasource] is responsible for starting a batch diagnosis,
/// checking its processing status, and retrieving the final diagnosis result
/// from a given backend implementation.
abstract class SceneDatasource {
  /// Starts the diagnosis process for a previously uploaded batch.
  ///
  /// The [batchId] identifies the group of frames already available on the
  /// backend.
  Future<Map<String, dynamic>> startDiagnosis(String batchId);

  /// Retrieves the current diagnosis status for the provided [batchId].
  ///
  /// Typical backend statuses include values such as `processing` and
  /// `completed`.
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId);

  /// Retrieves the final diagnosis result for the provided [batchId].
  ///
  /// The returned map contains the raw backend response, including metadata,
  /// performance metrics, summary information, recommendations, and frame-level
  /// results.
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId);
}

/// HTTP implementation of [SceneDatasource] using Dio.
///
/// This datasource communicates with the active backend stored in
/// [BackendSession]. It sends requests to the batch diagnosis endpoints and
/// returns the raw response maps to be adapted by higher layers.
class SceneDatasourceImpl implements SceneDatasource {
  /// HTTP client used to perform requests to the backend API.
  final Dio dio;

  /// Session object containing the active backend endpoint and timeout values.
  final BackendSession backendSession;

  /// Creates a scene datasource using the provided [dio] client and
  /// [backendSession].
  SceneDatasourceImpl(this.dio, this.backendSession);

  /// Starts the batch diagnosis process on the active backend.
  ///
  /// Sends a `POST` request to `/diagnose/batch/{batchId}`.
  @override
  Future<Map<String, dynamic>> startDiagnosis(String batchId) async {
    final response = await dio.post(
      '${backendSession.baseUrl}/diagnose/batch/$batchId',
      options: Options(
        sendTimeout: backendSession.diagnosisTimeout,
        receiveTimeout: backendSession.diagnosisTimeout,
      ),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  /// Retrieves the current processing status of a batch diagnosis.
  ///
  /// Sends a `GET` request to `/diagnose/batch/{batchId}/status`.
  @override
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId) async {
    final response = await dio.get(
      '${backendSession.baseUrl}/diagnose/batch/$batchId/status',
      options: Options(
        sendTimeout: backendSession.diagnosisTimeout,
        receiveTimeout: backendSession.diagnosisTimeout,
      ),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  /// Retrieves the final result of a completed batch diagnosis.
  ///
  /// Sends a `GET` request to `/diagnose/batch/{batchId}/result`.
  @override
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId) async {
    final response = await dio.get(
      '${backendSession.baseUrl}/diagnose/batch/$batchId/result',
      options: Options(
        sendTimeout: backendSession.diagnosisTimeout,
        receiveTimeout: backendSession.diagnosisTimeout,
      ),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }
}
