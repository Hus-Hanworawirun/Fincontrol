import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/portfolio_model.dart';

class PortfolioRepository {
  final FirebaseFirestore _firestore;

  PortfolioRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<PortfolioModel>> getPortfolios(String userId) {
    return _firestore
        .collection('portfolios')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PortfolioModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addPortfolio(PortfolioModel portfolio) async {
    await _firestore.collection('portfolios').add(portfolio.toMap());
  }

  Future<void> updatePortfolio(PortfolioModel portfolio) async {
    await _firestore.collection('portfolios').doc(portfolio.id).update(portfolio.toMap());
  }

  Future<void> deletePortfolio(String id) async {
    await _firestore.collection('portfolios').doc(id).delete();
  }
}
