import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioModel {
  final String id;
  final String userId;
  final String name;
  final int icon;
  final String note;
  final double? targetGoal;
  final DateTime createdAt;

  const PortfolioModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.note,
    this.targetGoal,
    required this.createdAt,
  });

  factory PortfolioModel.fromMap(Map<String, dynamic> map, String id) {
    return PortfolioModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      icon: map['icon'] as int? ?? 0,
      note: map['note'] as String? ?? '',
      targetGoal: (map['targetGoal'] as num?)?.toDouble(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'icon': icon,
      'note': note,
      'targetGoal': targetGoal,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
