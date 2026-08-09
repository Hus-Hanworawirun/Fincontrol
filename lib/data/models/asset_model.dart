class AssetModel {
  final String id;
  final String userId;
  final String portfolioId;
  final String name;
  final String category;
  final double totalQuantity;
  final double averageBuyPrice;
  final double currentPrice;

  const AssetModel({
    required this.id,
    required this.userId,
    required this.portfolioId,
    required this.name,
    required this.category,
    required this.totalQuantity,
    required this.averageBuyPrice,
    required this.currentPrice,
  });

  factory AssetModel.fromMap(Map<String, dynamic> map, String id) {
    return AssetModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      portfolioId: map['portfolioId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? '',
      totalQuantity: (map['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      averageBuyPrice: (map['averageBuyPrice'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (map['currentPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'portfolioId': portfolioId,
      'name': name,
      'category': category,
      'totalQuantity': totalQuantity,
      'averageBuyPrice': averageBuyPrice,
      'currentPrice': currentPrice,
    };
  }
}
