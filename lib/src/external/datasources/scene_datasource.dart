import 'dart:typed_data';
import 'package:dio/dio.dart';


abstract class SceneDatasource {
  Future<List<Map<String, dynamic>>> evaluateScene(
    List<Uint8List> frames,
  );
}

class SceneDatasourceImpl implements SceneDatasource {
  final Dio dio;

  SceneDatasourceImpl(this.dio);
  @override
  Future<List<Map<String, dynamic>>> evaluateScene(
    List<Uint8List> frames,
  ) async {
    final formData = FormData();

    for (int i = 0; i < frames.length; i++) {
      formData.files.add(
        MapEntry(
          'frames',
          MultipartFile.fromBytes(
            frames[i],
            filename: 'frame_$i.jpg',
          ),
        ),
      );
    }

    final response = await dio.post(
      'http://<IP-DO-BACKEND>:8000/scene/evaluate',
      data: formData,
    );

    return response.data;
  }
}
