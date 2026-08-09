import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  
  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final String userId;
  const LoadTransactions(this.userId);
  
  @override
  List<Object> get props => [userId];
}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;
  const AddTransaction(this.transaction);
  
  @override
  List<Object> get props => [transaction];
}

class TransactionsUpdated extends TransactionEvent {
  final List<TransactionModel> transactions;
  const TransactionsUpdated(this.transactions);
}

class TransactionFailed extends TransactionEvent {
  final String error;
  const TransactionFailed(this.error);
}
