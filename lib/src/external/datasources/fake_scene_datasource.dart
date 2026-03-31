// fake_scene_datasource.dart: implementação de um datasource falso para simular respostas do backend durante o desenvolvimento e testes da UI
import 'dart:math';
import 'scene_datasource.dart';

class FakeSceneDatasource implements SceneDatasource {
  // gerador de números aleatórios para simular resultados variados do diagnóstico
  final Random _random = Random();

  // mapa para armazenar o status de cada batch_id, simulando o processo de diagnóstico em andamento e concluído
  final Map<String, String> _status = {};
  
  // contador de polling para simular múltiplas requisições até completar o diagnóstico
  final Map<String, int> _pollCount = {};

  // método para iniciar o diagnóstico, simulando um atraso e definindo o status como "processing" para o batch_id fornecido
  @override
  Future<Map<String, dynamic>> startDiagnosis(String batchId) async {
    // simula latência de início do diagnóstico (~1.5s)
    await Future.delayed(const Duration(milliseconds: 1500));
    _status[batchId] = 'processing';
    _pollCount[batchId] = 0;

    return {"batch_id": batchId, "status": "processing"};
  }

  // método para obter o status do diagnóstico, simulando múltiplos polls até completar
  // polling 0-2: processing (~1s cada)
  // polling 3+: completed
  @override
  Future<Map<String, dynamic>> getDiagnosisStatus(String batchId) async {
    // simula latência de requisição (1s por poll para tornar visível)
    await Future.delayed(const Duration(milliseconds: 1200));

    // incrementa contador de polls para este batch
    _pollCount[batchId] = (_pollCount[batchId] ?? 0) + 1;
    final pollCount = _pollCount[batchId]!;

    // simula 3 polls em "processing" antes de completar (~3.6s total)
    if (pollCount >= 3) {
      _status[batchId] = 'completed';
    } else {
      _status[batchId] = 'processing';
    }

    return {"batch_id": batchId, "status": _status[batchId]};
  }

  // método para obter os resultados do diagnóstico, simulando um atraso e retornando dados fictícios com base no status do batch_id
  @override
  Future<Map<String, dynamic>> getDiagnosisResult(String batchId) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // simula um resultado positivo ou negativo de forma aleatória
    final isGood = _random.nextBool();
    
    // simula métricas de performance
    final pdiTotalMs = isGood ? _random.nextDouble() * 200 + 300 : _random.nextDouble() * 400 + 500;
    final pdiPerImageMs = pdiTotalMs / 10;
    final slmTotalS = isGood ? _random.nextDouble() + 1 : _random.nextDouble() * 2 + 2;
    final slmPerDiagnosisS = slmTotalS / 10;
    final totalS = pdiTotalMs / 1000 + slmTotalS;
    
    // simula métricas de acurácia
    final correctFrames = isGood ? 9 + _random.nextInt(2) : 4 + _random.nextInt(3);
    final totalFrames = 10;
    final accuracy = (correctFrames / totalFrames) * 100;
    
    // gera dados fictícios para cada frame
    final List<Map<String, dynamic>> framesList = [];
    for (int i = 0; i < totalFrames; i++) {
      framesList.add({
        "frame_id": i,
        "mean_luma": isGood ? 100 + _random.nextInt(30) : 40 + _random.nextInt(30),
        "uniformity": isGood ? 0.65 + _random.nextDouble() * 0.25 : 0.3 + _random.nextDouble() * 0.25,
        "score": isGood ? 0.8 + _random.nextDouble() * 0.2 : 0.4 + _random.nextDouble() * 0.3,
        "status": (isGood || i < correctFrames) ? "good" : "poor",
      });
    }

    return {
      "metadata": {
        "environment": "mobile_app",
        "model": "ar_scene_model_v2",
        "device": "flutter_simulator",
        "quantization": "fp32",
        "batch_size": 10,
      },
      "performance": {
        "pdi_total_ms": pdiTotalMs,
        "pdi_per_image_ms": pdiPerImageMs,
        "slm_total_s": slmTotalS,
        "slm_per_diagnosis_s": slmPerDiagnosisS,
        "total_s": totalS,
        "target_met": isGood,
      },
      "statistics": {
        "total": totalFrames,
        "correct": correctFrames,
        "accuracy": accuracy,
      },
      "summary": {
        "overall_risk": isGood ? "low" : "high",
        "dominant_label": isGood ? "adequate" : "underexposed",
        "problem_count": isGood ? 0 : (10 - correctFrames),
        "normal_count": isGood ? 10 : correctFrames,
        "explanation": isGood
            ? "Lighting conditions are ideal for AR. Contrast is sufficient and scene features are well-defined."
            : "Scene presents lighting issues affecting AR tracking. Low luminance and poor uniformity detected.",
        "recommendations": [
          {
            "condition": isGood ? "adequate" : "underexposed",
            "count": isGood ? 10 : (10 - correctFrames),
            "actions": isGood
                ? [
                    "Maintain current lighting conditions",
                    "Scene is ready for AR experience",
                    "Features are well-tracked",
                  ]
                : [
                    "Increase ambient lighting significantly",
                    "Avoid deep shadows and dark corners",
                    "Use indirect natural light when possible",
                    "Consider moving to a brighter location",
                  ],
          },
        ],
        "metrics_avg": {
          "mean_luma": isGood ? 100 + _random.nextDouble() * 30 : 40 + _random.nextDouble() * 30,
          "uniformity": isGood ? 0.65 + _random.nextDouble() * 0.3 : 0.3 + _random.nextDouble() * 0.25,
          "mean_brightness": isGood ? 0.5 + _random.nextDouble() * 0.4 : 0.1 + _random.nextDouble() * 0.3,
          "pct_clipped_bright": _random.nextDouble() * 0.01,
          "pct_clipped_dark": _random.nextDouble() * 0.005,
        },
      },
      "frames": framesList,
    };
  }
}
