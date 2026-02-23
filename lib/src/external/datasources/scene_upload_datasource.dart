// scene_upload_datasource.dart: responsável por enviar os frames para o backend e receber as informações de upload (ex: session_id) para cada frame
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class SceneUploadDatasource {
  // Recebe uma lista de frames (imagens) e retorna um mapa contendo as informações de upload para cada frame, como o session_id gerado no backend
  Future<Map<String, dynamic>> uploadFrames(
    List<Uint8List> frames, {
    String? sessionId,
  });
}

// Implementação concreta do SceneUploadDatasource usando a biblioteca Dio para fazer requisições HTTP
class SceneUploadDatasourceImpl implements SceneUploadDatasource {
  // Instância do Dio para realizar as requisições HTTP
  final Dio dio;

  SceneUploadDatasourceImpl(this.dio);

  // Método que envia os frames para o backend e recebe as informações de upload para cada frame
  @override
  Future<Map<String, dynamic>> uploadFrames(
    List<Uint8List> frames, {
    String? sessionId,
  }) async {
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

    // criar subpasta no backend
    if (sessionId != null) {
      formData.fields.add(MapEntry('session_id', sessionId));
    }

    // Envia uma requisição POST para o endpoint do backend responsável por fazer o upload dos frames, passando o FormData como corpo da requisição
    try {
      final response = await dio.post(
        // confirme que está usando seu IP real
        // 'http://192.168.15.4:8000/upload/batch', //
        // 'http://192.168.158.44:8000/upload/batch', // ip do lab no Softex_Conv
        'http://10.196.5.159:8000/upload/batch', // ip internet meu celular
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      // mostrar o erro real
      debugPrint('UPLOAD DioException.type = ${e.type}');
      debugPrint('UPLOAD DioException.message = ${e.message}');
      debugPrint('UPLOAD statusCode = ${e.response?.statusCode}');
      debugPrint('UPLOAD response.data = ${e.response?.data}');

      // devolver algo útil pra store/UI
      final detail = (e.response?.data is Map)
          ? (e.response?.data['detail']?.toString())
          : null;

      throw Exception(detail ?? e.message ?? 'Falha no upload (DioException)');
    } catch (e) {
      debugPrint('UPLOAD unknown error = $e');
      throw Exception('Falha no upload (erro desconhecido): $e');
    }
  }
}
