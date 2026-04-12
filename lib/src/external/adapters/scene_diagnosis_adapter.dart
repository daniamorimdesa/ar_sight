// scene_diagnosis_adapter.dart: adaptador para converter a resposta bruta do backend em um objeto SceneDiagnosis estruturado
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../models/recommendation_group.dart';
import '../../models/scene_diagnosis.dart';

class SceneDiagnosisAdapter {
  static SceneDiagnosis fromBackend(Map<String, dynamic> map) {
    // DEBUG: Exibir JSON completo da resposta do backend
    if (kDebugMode) {
      debugPrint('=== BACKEND RESPONSE JSON ===');
      debugPrint(JsonEncoder.withIndent('  ').convert(map));
      debugPrint('============================');
      debugPrint('Metadata received: ${map['metadata']}');
    }

    final metadata = Map<String, dynamic>.from(map['metadata'] ?? {});
    final performance = Map<String, dynamic>.from(map['performance'] ?? {});
    final statistics = Map<String, dynamic>.from(map['statistics'] ?? {});
    final summary = Map<String, dynamic>.from(map['summary'] ?? {});
    final frames = List<Map<String, dynamic>>.from(
      (map['frames'] ?? []).map((e) => Map<String, dynamic>.from(e)),
    );

    final overallRisk = (summary['overall_risk'] ?? 'unknown').toString();
    final dominantLabel = (summary['dominant_label'] ?? 'unknown').toString();
    final explanation = (summary['explanation'] ?? '').toString();

    final normalCount = summary['normal_count'] ?? 0;
    final problemCount = summary['problem_count'] ?? 0;
    
    // Processing time vem de summary.processing_time_s ou usa total_s de performance
    final processingTimeS = ((summary['processing_time_s'] ?? performance['total_s'] ?? 0) as num).toStringAsFixed(2);

    final recommendationsRaw = summary['recommendations'] ?? [];
    final List<String> recommendations = [];
    for (final r in recommendationsRaw) {
      final actions = r['actions'] ?? [];
      recommendations.addAll(List<String>.from(actions));
    }

    final isPass = overallRisk.toLowerCase() == 'low';

    // Gerar RecommendationGroups
    final recommendationGroups = _buildRecommendationGroups(
      isPass: isPass,
      recommendationsRaw: recommendationsRaw,
      frames: frames,
    );

    return SceneDiagnosis(
      status: isPass ? 'pass' : 'fail',
      riskLevel: overallRisk,
      dominantLabel: dominantLabel,
      explanation: explanation,
      recommendations: recommendations,
      recommendationGroups: recommendationGroups,
      normalCount: normalCount,
      problemCount: problemCount,
      processingTime: '${processingTimeS}s',

      environment: (metadata['environment'] ?? 'Backend Processing').toString(),
      model: (metadata['model'] ?? 'Unknown Model').toString(),
      device: (metadata['device'] ?? 'Unknown Device').toString(),
      quantization: (metadata['quantization'] ?? 'Not Specified').toString(),
      batchSize: metadata['batch_size'] ?? 0,

      pdiTotalMs: (performance['pdi_total_ms'] ?? 0.0).toDouble(),
      pdiPerImageMs: (performance['pdi_per_image_ms'] ?? 0.0).toDouble(),
      slmTotalS: (performance['slm_total_s'] ?? 0.0).toDouble(),
      slmPerDiagnosisS: (performance['slm_per_diagnosis_s'] ?? 0.0).toDouble(),
      totalS: (performance['total_s'] ?? 0.0).toDouble(),
      targetMet: performance['target_met'] ?? isPass,

      totalFrames: statistics['total'] ?? 0,
      correctFrames: statistics['correct'] ?? 0,
      accuracy: (statistics['accuracy'] ?? 0).toDouble(),

      metricsAvg: Map<String, dynamic>.from(summary['metrics_avg'] ?? {}),
      frames: frames,
    );
  }

  static List<RecommendationGroup> _buildRecommendationGroups({
    required bool isPass,
    required List<dynamic> recommendationsRaw,
    required List<Map<String, dynamic>> frames,
  }) {
    final groups = <RecommendationGroup>[];

    if (isPass) {
      // Para cenas boas (pass), criar um grupo com condition="adequate_acceptable"
      final recommendations = <String>[];
      for (final r in recommendationsRaw) {
        final actions = r['actions'] ?? [];
        recommendations.addAll(List<String>.from(actions));
      }

      if (recommendations.isNotEmpty) {
        groups.add(RecommendationGroup(
          condition: 'adequate_acceptable',
          frames: null,
          actions: recommendations,
        ));
      }
    } else {
      // Para cenas ruins (fail), agrupar por illumination_label dos frames
      // Mapear cada condition (ex: underexposed, overexposed) para seus frames
      final conditionMap = <String, List<int>>{};

      for (int i = 0; i < frames.length; i++) {
        final frame = frames[i];
        final metrics = frame['metrics'] ?? {};
        final illuminationLabel = (metrics['illumination_label'] ?? 'unknown').toString().toLowerCase();

        // Ignorar frames com condição normal
        if (illuminationLabel == 'normal' || illuminationLabel == 'adequate' || illuminationLabel == 'ideal') {
          continue;
        }

        if (!conditionMap.containsKey(illuminationLabel)) {
          conditionMap[illuminationLabel] = [];
        }
        // Adicionar o índice do frame (1-based)
        conditionMap[illuminationLabel]!.add(i + 1);
      }

      // Para cada condition encontrada, buscar as ações correspondentes no backend
      final recMap = <String, List<String>>{};
      for (final r in recommendationsRaw) {
        final condition = r['condition']?.toString().toLowerCase() ?? '';
        final actions = List<String>.from(r['actions'] ?? []);
        
        if (condition.isNotEmpty && actions.isNotEmpty) {
          recMap[condition] = actions;
        }
      }

      // Criar os grupos
      final sortedConditions = conditionMap.keys.toList();
      sortedConditions.sort(); // ordenar alfabeticamente para consistência

      for (final condition in sortedConditions) {
        final frameIndices = conditionMap[condition]!;
        final actions = recMap[condition] ?? [];

        // Se não houver ações específicas no backend, gerar padrões
        if (actions.isEmpty) {
          actions.addAll(_getDefaultActionsForCondition(condition));
        }

        groups.add(RecommendationGroup(
          condition: condition,
          frames: frameIndices,
          actions: actions,
        ));
      }
    }

    return groups;
  }

  static List<String> _getDefaultActionsForCondition(String condition) {
    final conditionLower = condition.toLowerCase();

    if (conditionLower.contains('underexposed')) {
      return [
        'Increase ambient lighting or use supplemental light sources',
        'Position light sources to evenly illuminate the scene',
        'Ensure the camera lens is not obstructed',
      ];
    } else if (conditionLower.contains('overexposed')) {
      return [
        'Avoid pointing camera directly at bright light sources',
        'Reduce direct lighting or use diffusers to soften harsh light',
        'Reposition to avoid strong backlighting',
      ];
    } else if (conditionLower.contains('uneven') || conditionLower.contains('mixed')) {
      return [
        'Move to a location with more uniform lighting',
        'Use additional light sources to fill shadow areas',
        'Avoid mixed light sources (natural + artificial)',
      ];
    }

    // Default fallback
    return [
      'Adjust the lighting conditions of the scene',
      'Try repositioning to find better lighting',
    ];
  }
}