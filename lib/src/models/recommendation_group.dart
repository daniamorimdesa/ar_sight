/// Represents a group of recommendations associated with a scene condition.
///
/// A [RecommendationGroup] groups corrective actions by diagnosis condition,
/// such as `underexposed`, `overexposed`, or `adequate_acceptable`. When
/// [frames] is provided, the recommendations are associated with specific
/// frame indices in the captured batch.
class RecommendationGroup {
  /// Diagnosis condition associated with this recommendation group.
  ///
  /// Expected values include `adequate_acceptable`, `underexposed`,
  /// `overexposed`, or other backend-defined condition labels.
  final String? condition;

  /// One-based frame indices associated with this condition.
  ///
  /// A `null` value indicates that the recommendation applies to the scene as
  /// a whole rather than to specific frames.
  final List<int>? frames;

  /// Corrective actions or recommendations for this condition.
  final List<String> actions;

  /// Creates a recommendation group for a diagnosis condition.
  RecommendationGroup({this.condition, this.frames, required this.actions});

  /// Whether this group represents a high-level recommendation for an
  /// adequate or acceptable scene.
  bool get isAdequate => condition == 'adequate_acceptable' && frames == null;

  /// User-facing label describing the affected frames.
  ///
  /// Returns `null` when this recommendation group is not associated with
  /// specific frame indices.
  String? get frameLabel {
    if (frames == null || frames!.isEmpty || condition == null) {
      return null;
    }

    final frameStr = frames!.join(', ');
    final frameWord = frames!.length > 1 ? 'frames' : 'frame';
    final formattedCondition = _formatCondition(condition!);

    return '$formattedCondition $frameWord: $frameStr';
  }

  /// Converts a backend condition identifier into a readable label.
  String _formatCondition(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
