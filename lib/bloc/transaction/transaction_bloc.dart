import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../data/repositories/transaction_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  StreamSubscription? _transactionSubscription;

  TransactionBloc({required this._transactionRepository})
      : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<TransactionsUpdated>((event, emit) => emit(TransactionLoaded(event.transactions)));
    on<TransactionFailed>((event, emit) => emit(TransactionError(event.error)));
  }

  void _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    await _transactionSubscription?.cancel();
    _transactionSubscription = _transactionRepository.getTransactions(event.userId).listen(
      (transactions) {
        if (!isClosed) {
          add(TransactionsUpdated(transactions));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(TransactionFailed(error.toString()));
        }
      },
    );
  }

  void _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    try {
      await _transactionRepository.addTransaction(event.transaction);
    } catch (e) {
      if (!isClosed) emit(TransactionError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}
