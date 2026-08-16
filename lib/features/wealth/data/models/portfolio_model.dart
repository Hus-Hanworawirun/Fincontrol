class PortfolioModel {
  final String id;
  final String userId;
  final String name;
  final int icon;
  final String note;
  final double? targetGoal;
  final DateTime createdAt;
  final double totalValue;
  final double change;
  final double changePercent;
  final String currentTrend;

  const PortfolioModel({
    required this.id,
    required this.userId,
    required this.name,
    this.icon = 0,
    this.note = '',
    this.targetGoal,
    required this.createdAt,
    this.totalValue = 0.0,
    this.change = 0.0,
    this.changePercent = 0.0,
    this.currentTrend = 'up',
  });

  factory PortfolioModel.fromMap(Map<String, dynamic> map, String id) {
    return PortfolioModel(
      id: id,
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      icon: map['icon'] as int? ?? 0,
      note: map['note'] as String? ?? '',
      targetGoal: (map['targetGoal'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now() : DateTime.now(),
      totalValue: (map['total_value'] as num?)?.toDouble() ?? 0.0,
      change: (map['change'] as num?)?.toDouble() ?? 0.0,
      changePercent: (map['change_percent'] as num?)?.toDouble() ?? 0.0,
      currentTrend: map['current_trend'] as String? ?? 'up',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'icon': icon,
      'note': note,
      'targetGoal': targetGoal,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
