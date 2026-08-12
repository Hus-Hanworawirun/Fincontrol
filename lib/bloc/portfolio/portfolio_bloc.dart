import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';
import '../../data/repositories/portfolio_repository.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _portfolioRepository;
  StreamSubscription? _portfolioSubscription;

  PortfolioBloc({required this._portfolioRepository})
      : super(PortfolioInitial()) {
    on<LoadPortfolios>(_onLoadPortfolios);
    on<AddPortfolio>(_onAddPortfolio);
    on<PortfoliosUpdated>((event, emit) => emit(PortfolioLoaded(event.portfolios)));
    on<PortfolioFailed>((event, emit) => emit(PortfolioError(event.error)));
  }

  void _onLoadPortfolios(LoadPortfolios event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());
    await _portfolioSubscription?.cancel();
    _portfolioSubscription = _portfolioRepository.getPortfolios(event.userId).listen(
      (portfolios) {
        if (!isClosed) {
          add(PortfoliosUpdated(portfolios));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(PortfolioFailed(error.toString()));
        }
      },
    );
  }

  void _onAddPortfolio(AddPortfolio event, Emitter<PortfolioState> emit) async {
    try {
      await _portfolioRepository.addPortfolio(event.portfolio);
    } catch (e) {
      if (!isClosed) emit(PortfolioError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _portfolioSubscription?.cancel();
    return super.close();
  }
}
