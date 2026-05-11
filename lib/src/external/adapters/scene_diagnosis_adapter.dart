import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../models/recommendation_group.dart';
import '../../models/scene_diagnosis.dart';

/// Converts raw backend diagnosis responses into structured [SceneDiagnosis]
/// instances used by the presentation layer.
///
/// The backend response contains nested metadata, performance metrics,
/// statistics, frame-level results, and recommendation data. This adapter
/// centralizes the parsing logic so that UI components can work with a
/// consistent domain model instead of handling raw JSON maps directly.
class SceneDiagnosisAdapter {
  /// Creates a [SceneDiagnosis] from a backend response [map].
  ///
  /// Missing or incomplete fields are replaced with safe fallback values to
  /// keep the application stable when optional backend data is unavailable.
  static SceneDiagnosis fromBackend(Map<String, dynamic> map) {
    if (kDebugMode) {
      debugPrint('=== BACKEND RESPONSE JSON ===');
      debugPrint(const JsonEncoder.withIndent('  ').convert(map));
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

    // Prefer the summarized processing time, but fall back to the total
    // performance time when the summary field is not provided.
    final processingTimeS =
        ((summary['processing_time_s'] ?? performance['total_s'] ?? 0) as num)
            .toStringAsFixed(2);

    final recommendationsRaw = summary['recommendations'] ?? [];
    final List<String> recommendations = [];

    for (final r in recommendationsRaw) {
      final actions = r['actions'] ?? [];
      recommendations.addAll(List<String>.from(actions));
    }

    final isPass = overallRisk.toLowerCase() == 'low';

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

  /// Builds recommendation groups according to the diagnosis outcome.
  ///
  /// Passing scenes receive a single general recommendation group, while
  /// failing scenes are grouped by frame illumination condition. This allows
  /// the UI to display both the affected frame indices and the corresponding
  /// corrective actions.
  static List<RecommendationGroup> _buildRecommendationGroups({
    required bool isPass,
    required List<dynamic> recommendationsRaw,
    required List<Map<String, dynamic>> frames,
  }) {
    final groups = <RecommendationGroup>[];

    if (isPass) {
      final recommendations = <String>[];

      for (final r in recommendationsRaw) {
        final actions = r['actions'] ?? [];
        recommendations.addAll(List<String>.from(actions));
      }

      if (recommendations.isNotEmpty) {
        groups.add(
          RecommendationGroup(
            condition: 'adequate_acceptable',
            frames: null,
            actions: recommendations,
          ),
        );
      }
    } else {
      final conditionMap = <String, List<int>>{};

      for (int i = 0; i < frames.length; i++) {
        final frame = frames[i];
        final metrics = frame['metrics'] ?? {};
        final illuminationLabel = (metrics['illumination_label'] ?? 'unknown')
            .toString()
            .toLowerCase();

        // Frames classified as normal do not require corrective action groups.
        if (illuminationLabel == 'normal' ||
            illuminationLabel == 'adequate' ||
            illuminationLabel == 'ideal') {
          continue;
        }

        conditionMap.putIfAbsent(illuminationLabel, () => []);

        // Frame numbers are stored as 1-based indices for user-facing display.
        conditionMap[illuminationLabel]!.add(i + 1);
      }

      final recMap = <String, List<String>>{};

      for (final r in recommendationsRaw) {
        final condition = r['condition']?.toString().toLowerCase() ?? '';
        final actions = List<String>.from(r['actions'] ?? []);

        if (condition.isNotEmpty && actions.isNotEmpty) {
          recMap[condition] = actions;
        }
      }

      final sortedConditions = conditionMap.keys.toList()..sort();

      for (final condition in sortedConditions) {
        final frameIndices = conditionMap[condition]!;
        final actions = recMap[condition] ?? [];

        // Use local fallback actions when the backend does not provide
        // condition-specific recommendations.
        if (actions.isEmpty) {
          actions.addAll(_getDefaultActionsForCondition(condition));
        }

        groups.add(
          RecommendationGroup(
            condition: condition,
            frames: frameIndices,
            actions: actions,
          ),
        );
      }
    }

    return groups;
  }

  /// Returns fallback corrective actions for a given illumination [condition].
  ///
  /// These recommendations are used only when the backend response does not
  /// include condition-specific actions.
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
    } else if (conditionLower.contains('uneven') ||
        conditionLower.contains('mixed')) {
      return [
        'Move to a location with more uniform lighting',
        'Use additional light sources to fill shadow areas',
        'Avoid mixed light sources (natural + artificial)',
      ];
    }

    return [
      'Adjust the lighting conditions of the scene',
      'Try repositioning to find better lighting',
    ];
  }
}
