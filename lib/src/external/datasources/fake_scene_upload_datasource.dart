import 'dart:math';
import 'dart:typed_data';
import 'scene_upload_datasource.dart';

/// Fake implementation of [SceneUploadDatasource] used for UI development
/// and testing.
///
/// This datasource simulates the upload of captured frames without requiring
/// a real backend connection. It returns mock upload metadata such as a batch
/// identifier, upload status, and the number of files received.
class FakeSceneUploadDatasource implements SceneUploadDatasource {
  /// Random generator used to introduce small variations in simulated latency.
  final Random _random = Random();

  /// Simulates the upload of a list of image [frames].
  ///
  /// Throws an [Exception] when no frames are provided. Otherwise, waits for a
  /// short artificial delay and returns a mock backend response containing
  /// upload information.
  @override
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames) async {
    if (frames.isEmpty) {
      throw Exception('No frames provided for upload.');
    }

    // Simulate upload latency to make UI loading transitions visible.
    final uploadDuration = Duration(
      milliseconds: 2000 + (frames.length * 200) + _random.nextInt(500),
    );

    await Future.delayed(uploadDuration);

    return {
      'batch_id': 'batch_mock_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'uploaded',
      'files_saved': frames.length,
      'total_files': frames.length,
    };
  }
}
