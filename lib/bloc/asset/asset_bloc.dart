import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'asset_event.dart';
import 'asset_state.dart';
import '../../data/repositories/asset_repository.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepository _assetRepository;
  StreamSubscription? _assetSubscription;

  AssetBloc({required AssetRepository assetRepository})
      : _assetRepository = assetRepository,
        super(AssetInitial()) {
    on<LoadAssets>(_onLoadAssets);
    on<AddAsset>(_onAddAsset);
    on<AssetsUpdated>((event, emit) => emit(AssetLoaded(event.assets)));
    on<AssetFailed>((event, emit) => emit(AssetError(event.error)));
  }

  void _onLoadAssets(LoadAssets event, Emitter<AssetState> emit) async {
    emit(AssetLoading());
    await _assetSubscription?.cancel();
    _assetSubscription = _assetRepository.getAssets(event.portfolioId).listen(
      (assets) {
        if (!isClosed) {
          add(AssetsUpdated(assets));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(AssetFailed(error.toString()));
        }
      },
    );
  }

  void _onAddAsset(AddAsset event, Emitter<AssetState> emit) async {
    try {
      await _assetRepository.addAsset(event.asset);
    } catch (e) {
      if (!isClosed) emit(AssetError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _assetSubscription?.cancel();
    return super.close();
  }
}
