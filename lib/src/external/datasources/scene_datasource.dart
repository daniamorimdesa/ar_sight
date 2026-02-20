// scene_datasource.dart: responsável por enviar os frames para o backend e receber as informações de cena avaliadas.
import 'dart:typed_data';
import 'package:dio/dio.dart';

abstract class SceneDatasource {
  // Recebe uma lista de frames (imagens) e retorna uma lista de mapas contendo as informações de cena avaliadas para cada frame
  Future<List<Map<String, dynamic>>> evaluateScene(List<Uint8List> frames);
}

// Implementação concreta do SceneDatasource usando a biblioteca Dio para fazer requisições HTTP
class SceneDatasourceImpl implements SceneDatasource {
  final Dio dio; // Instância do Dio para realizar as requisições HTTP

  SceneDatasourceImpl(this.dio);

  // Método que envia os frames para o backend e recebe as informações de cena avaliadas
  @override
  Future<List<Map<String, dynamic>>> evaluateScene(
    List<Uint8List> frames,
  ) async {
    // Cria um FormData para enviar os arquivos como multipart/form-data
    final formData = FormData();

    // Adiciona cada frame como um arquivo no FormData, nomeando-os como "frame_0.jpg", "frame_1.jpg", etc
    for (int i = 0; i < frames.length; i++) {
      formData.files.add(
        MapEntry(
          'frames',
          MultipartFile.fromBytes(frames[i], filename: 'frame_$i.jpg'),
        ),
      );
    }

    // Envia uma requisição POST para o endpoint do backend responsável por avaliar a cena, passando o FormData como corpo da requisição
    final response = await dio.post(
      'http://<IP-DO-BACKEND>:8000/scene/evaluate',
      data: formData,
    );

    // Retorna os dados da resposta, que devem conter as informações de cena avaliadas para cada frame
    return response.data;
  }
}
