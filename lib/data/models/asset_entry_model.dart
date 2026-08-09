import 'package:cloud_firestore/cloud_firestore.dart';

class AssetEntryModel {
  final String id;
  final String assetId;
  final String type;
  final double quantity;
  final double price;
  final String note;
  final DateTime date;

  const AssetEntryModel({
    required this.id,
    required this.assetId,
    required this.type,
    required this.quantity,
    required this.price,
    required this.note,
    required this.date,
  });

  factory AssetEntryModel.fromMap(Map<String, dynamic> map, String id) {
    return AssetEntryModel(
      id: id,
      assetId: map['assetId'] as String? ?? '',
      type: map['type'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      note: map['note'] as String? ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'type': type,
      'quantity': quantity,
      'price': price,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }
}
