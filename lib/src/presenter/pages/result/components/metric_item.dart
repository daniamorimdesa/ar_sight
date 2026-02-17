import 'package:flutter/material.dart';

class MetricItem {
  final String title;
  final String value;
  final IconData icon;

  MetricItem({required this.title, required this.value, required this.icon});
}

/// Tenta transformar suas evidenceMetrics em cards "bonitos".
/// Aceita strings como:
/// - "lighting: good"
/// - "occlusion_level=medium"
/// - "illumination"
List<MetricItem> buildMetricsFromEvidence(List<String> evidence) {
  IconData pickIcon(String key) {
    final k = key.toLowerCase();

    if (k.contains('illum')) return Icons.wb_sunny_outlined;
    if (k.contains('occlusion')) return Icons.visibility_outlined;
    if (k.contains('reflection')) return Icons.blur_on_outlined;
    if (k.contains('people')) return Icons.person_outline_rounded;

    return Icons.analytics_outlined;
  }

  String prettyTitle(String key) {
    final k = key.toLowerCase();

    if (k.contains('illum')) return 'Lighting';
    if (k.contains('occlusion')) return 'Occlusion';
    if (k.contains('reflection')) return 'Reflections';
    if (k.contains('people')) return 'People';

    return key.replaceAll('_', ' ').trim();
  }

  if (evidence.isEmpty) return [];

  return evidence.map((raw) {
    return MetricItem(
      title: prettyTitle(raw),
      value: 'Detected',
      icon: pickIcon(raw),
    );
  }).toList();
}
