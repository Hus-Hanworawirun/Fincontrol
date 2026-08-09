import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/asset_model.dart';

class AssetRepository {
  final FirebaseFirestore _firestore;

  AssetRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<AssetModel>> getAssets(String portfolioId) {
    return _firestore
        .collection('assets')
        .where('portfolioId', isEqualTo: portfolioId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AssetModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addAsset(AssetModel asset) async {
    await _firestore.collection('assets').add(asset.toMap());
  }

  Future<void> updateAssetCurrentPrice(String id, double currentPrice) async {
    await _firestore.collection('assets').doc(id).update({'currentPrice': currentPrice});
  }
}
