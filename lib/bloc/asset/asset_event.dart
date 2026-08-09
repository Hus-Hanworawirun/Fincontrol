import 'package:equatable/equatable.dart';
import '../../data/models/asset_model.dart';

abstract class AssetEvent extends Equatable {
  const AssetEvent();
  
  @override
  List<Object> get props => [];
}

class LoadAssets extends AssetEvent {
  final String portfolioId;
  const LoadAssets(this.portfolioId);
  
  @override
  List<Object> get props => [portfolioId];
}

class AddAsset extends AssetEvent {
  final AssetModel asset;
  const AddAsset(this.asset);
  
  @override
  List<Object> get props => [asset];
}

class SyncAssetPrices extends AssetEvent {
  final String portfolioId;
  const SyncAssetPrices(this.portfolioId);
  
  @override
  List<Object> get props => [portfolioId];
}

class AssetsUpdated extends AssetEvent {
  final List<AssetModel> assets;
  const AssetsUpdated(this.assets);
}

class AssetFailed extends AssetEvent {
  final String error;
  const AssetFailed(this.error);
}
