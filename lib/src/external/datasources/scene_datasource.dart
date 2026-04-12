// scene_datasource.dart: responsável por enviar os frames para o backend e receber as informações de cena avaliadas.
import 'package:dio/dio.dart';

import '../config/backend_session.dart';

// Interface abstrata para o datasource de cena, definindo os métodos para iniciar o diagnóstico, obter o status do diagnóstico e obter o resultado do diagnóstico
abstract class SceneDatasource {
  Future<Map<String, dynamic>> startDiagnosis(String batchId);
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId);
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId);
}

// Implementação concreta do SceneDatasource usando a biblioteca Dio para fazer requisições HTTP para o backend
class SceneDatasourceImpl implements SceneDatasource {
  // Instância do Dio para realizar as requisições HTTP
  final Dio dio;
  final BackendSession backendSession;

  SceneDatasourceImpl(this.dio, this.backendSession);

  // Método para iniciar o diagnóstico, enviando uma requisição POST para o endpoint do backend responsável por iniciar o diagnóstico em lote
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

  // Método para obter o status do diagnóstico, enviando uma requisição GET para o endpoint do backend responsável por retornar o status do diagnóstico em lote
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

  // Método para obter o resultado do diagnóstico, enviando uma requisição GET para o endpoint do backend responsável por retornar o resultado do diagnóstico em lote
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
