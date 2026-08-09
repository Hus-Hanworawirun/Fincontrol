import 'package:equatable/equatable.dart';
import '../../data/models/portfolio_model.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();
  
  @override
  List<Object> get props => [];
}

class LoadPortfolios extends PortfolioEvent {
  final String userId;
  const LoadPortfolios(this.userId);
  
  @override
  List<Object> get props => [userId];
}

class AddPortfolio extends PortfolioEvent {
  final PortfolioModel portfolio;
  const AddPortfolio(this.portfolio);
  
  @override
  List<Object> get props => [portfolio];
}

class PortfoliosUpdated extends PortfolioEvent {
  final List<PortfolioModel> portfolios;
  const PortfoliosUpdated(this.portfolios);
}

class PortfolioFailed extends PortfolioEvent {
  final String error;
  const PortfolioFailed(this.error);
}
