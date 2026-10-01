import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/cache/api_cache_service.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/item_usecase.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_state.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class ItemFetchBloc extends Bloc<ItemFetchEvent, ItemFetchState> {
  final GetItemsUseCase getItemsUsecase;
  final UserStorageService storage;
  final ApiCacheService apiCache;

  ItemFetchBloc(this.getItemsUsecase, this.storage, this.apiCache)
    : super(ItemFetchInitial()) {
    on<FetchItems>(_onFetchItems);
  }

  Future<void> _onFetchItems(
    FetchItems event,
    Emitter<ItemFetchState> emit,
  ) async {
    final id = await storage.getUserId();

    if (id == null) {
      emit(const ItemFetchError('User not found'));
      return;
    }

    // A user-initiated refresh must reach the network, so drop any cached copy.
    if (event.forceRefresh) {
      apiCache.invalidatePrefix('/agents/profile/');
    } else if (state is! ItemFetchLoaded) {
      // Stale-while-revalidate: render the last known-good catalog instantly.
      final cached = await getItemsUsecase.getCached(id: id);
      if (cached != null && cached.isNotEmpty) {
        emit(ItemFetchLoaded(cached, isFromCache: true));
      }
    }

    // Only show a loader when we truly have nothing to paint yet.
    if (state is! ItemFetchLoaded) {
      emit(ItemFetchLoading());
    }

    try {
      final items = await getItemsUsecase(id: id);

      emit(ItemFetchLoaded(items));
    } catch (e) {
      // Keep showing whatever we already painted (fresh or cached).
      if (state is ItemFetchLoaded) return;
      emit(ItemFetchError(e.toString()));
    }
  }
}