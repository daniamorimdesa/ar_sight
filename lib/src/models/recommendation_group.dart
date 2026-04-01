// recommendation_group.dart: modelo para agrupar recomendações por condition/tipo de problema

class RecommendationGroup {
  final String? condition;  // "adequate_acceptable", "underexposed", "overexposed", etc
  final List<int>? frames;   // lista de índices de frames (1-based) que têm este problema
  final List<String> actions; // lista de ações/recomendações para este grupo

  RecommendationGroup({
    this.condition,
    this.frames,
    required this.actions,
  });

  // Getter para verificar se é uma recomendação de cena adequada (high-level)
  bool get isAdequate => condition == 'adequate_acceptable' && frames == null;

  // Getter para o label exibível dos frames
  String? get frameLabel {
    if (frames == null || frames!.isEmpty) return null;
    
    final frameStr = frames!.join(',');
    
    if (condition == null) return null;
    
    // Formatar: "Underexposed frames: 1,2,5" ou "Overexposed frame: 4"
    final frameWord = frames!.length > 1 ? 'frames' : 'frame';
    return '$condition $frameWord: $frameStr';
  }
}
