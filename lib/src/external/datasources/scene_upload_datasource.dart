// scene_upload_datasource.dart: responsável por enviar os frames para o backend e receber as informações de upload
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Interface abstrata para o datasource de upload de cena, definindo o método para enviar os frames para o backend e receber as informações de upload
abstract class SceneUploadDatasource {
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames);
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Implementação concreta do SceneUploadDatasource usando a biblioteca Dio para fazer requisições HTTP para o backend
class SceneUploadDatasourceImpl implements SceneUploadDatasource {
  // Instância do Dio para realizar as requisições HTTP
  final Dio dio;

  SceneUploadDatasourceImpl(this.dio);

  // Substituir pelo IP do backend
  static const String baseUrl = 'http://10.196.5.159:8000';

  // Método para enviar os frames para o backend e receber as informações de upload para cada frame, como o batch_id gerado no backend
  @override
  Future<Map<String, dynamic>> uploadFrames(List<Uint8List> frames) async {
    // Verifica se a lista de frames está vazia e lança uma exceção se for o caso, para evitar enviar uma requisição sem arquivos
    if (frames.isEmpty) {
      throw Exception('Nenhum frame fornecido para upload');
    }

    // Cria um FormData para enviar os arquivos como multipart/form-data
    final formData = FormData();

    // a rota usa "files" como nome do campo para os arquivos, então nomeamos cada frame como "files"
    for (int i = 0; i < frames.length; i++) {
      formData.files.add(
        MapEntry(
          'files',
          MultipartFile.fromBytes(frames[i], filename: 'frame_$i.jpg'),
        ),
      );
    }

    // Envia uma requisição POST para o endpoint do backend responsável por fazer o upload dos frames, passando o FormData como corpo da requisição
    final response = await dio.post(
      '$baseUrl/upload/batch',
      data: formData,
      options: Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    // Retorna a resposta do backend como um mapa contendo as informações de upload para cada frame, como o batch_id gerado no backend
    final data = Map<String, dynamic>.from(response.data as Map);

    // Verifica se a resposta contém o campo "batch_id" e lança uma exceção se não for encontrado
    if (!data.containsKey('batch_id')) {
      throw Exception('Resposta inválida: batch_id não encontrado');
    }

    // Imprime a resposta do upload no console para fins de depuração
    debugPrint('UPLOAD response: $data');

    return data;
  }
}
