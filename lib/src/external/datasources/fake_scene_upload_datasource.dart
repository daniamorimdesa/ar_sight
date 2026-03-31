// fake_scene_upload_datasource.dart: implementação fake do SceneUploadDatasource, simulando o upload de frames para o backend e retornando informações de upload fictícias, como batch_id, status, arquivos salvos e total de arquivos
import 'dart:math';
import 'dart:typed_data';
import 'scene_upload_datasource.dart';

class FakeSceneUploadDatasource implements SceneUploadDatasource {
  final Random _random = Random();

  @override
  Future<Map<String, dynamic>> uploadFrames(
    List<Uint8List> frames, {
    String? sessionId,
  }) async {
    // valida se há frames para fazer upload
    if (frames.isEmpty) {
      throw Exception('Nenhum frame fornecido para upload');
    }

    // simula latência de upload (~2-3s) para tornar a transição visível
    final uploadDuration = Duration(
      milliseconds: 2000 + (frames.length * 200) + _random.nextInt(500),
    );
    await Future.delayed(uploadDuration);

    return {
      "batch_id": "batch_mock_${DateTime.now().millisecondsSinceEpoch}",
      "status": "uploaded",
      "files_saved": frames.length,
      "total_files": frames.length,
    };
  }
}