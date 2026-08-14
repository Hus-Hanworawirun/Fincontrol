import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _firestore.collection('transactions').add(transaction.toMap());
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id.isEmpty) return;
    await _firestore.collection('transactions').doc(transaction.id).update(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await _firestore.collection('transactions').doc(id).delete();
  }
}
