import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/backend_session.dart';

/// Defines the contract for uploading scene frames to a backend.
///
/// A [SceneUploadDatasource] receives a list of captured image frames and
/// sends them to the backend so that they can be stored as a diagnosis batch.
abstract class SceneUploadDatasource {
  /// Uploads a list of image [frames] to the backend.
  ///
  /// Returns the raw upload response, which is expected to include the
  /// generated batch identifier used by the diagnosis pipeline.
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames);
}

/// HTTP implementation of [SceneUploadDatasource] using Dio.
///
/// This datasource sends captured frames to the active backend stored in
/// [BackendSession] using a multipart/form-data request.
class SceneUploadDatasourceImpl implements SceneUploadDatasource {
  /// HTTP client used to perform upload requests.
  final Dio dio;

  /// Session object containing the active backend endpoint.
  final BackendSession backendSession;

  /// Creates a scene upload datasource using the provided [dio] client and
  /// [backendSession].
  SceneUploadDatasourceImpl(this.dio, this.backendSession);

  /// Uploads captured image [frames] to the active backend.
  ///
  /// The backend expects each frame to be sent through the `files` multipart
  /// field. The response must contain a `batch_id`, which is later used to
  /// start and track the batch diagnosis process.
  @override
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames) async {
    if (frames.isEmpty) {
      throw Exception('No frames provided for upload.');
    }

    final formData = FormData();

    for (int i = 0; i < frames.length; i++) {
      formData.files.add(
        MapEntry(
          'files',
          MultipartFile.fromBytes(frames[i], filename: 'frame_$i.jpg'),
        ),
      );
    }

    final response = await dio.post(
      '${backendSession.baseUrl}/upload/batch',
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    final data = Map<String, dynamic>.from(response.data as Map);

    if (!data.containsKey('batch_id')) {
      throw Exception('Invalid response: batch_id not found.');
    }

    debugPrint('Upload response: $data');

    return data;
  }
}
