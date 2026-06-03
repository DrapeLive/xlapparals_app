import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/item_usecase.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_state.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class ItemFetchBloc extends Bloc<ItemFetchEvent, ItemFetchState> {
  final GetItemsUseCase getItemsUsecase;
  final UserStorageService storage;

  ItemFetchBloc(this.getItemsUsecase, this.storage)
    : super(ItemFetchInitial()) {
    on<FetchItems>(_onFetchItems);
  }

  Future<void> _onFetchItems(
    FetchItems event,
    Emitter<ItemFetchState> emit,
  ) async {
    emit(ItemFetchLoading());

    try {
      final id = await storage.getUserId();

      if (id == null) {
        emit(const ItemFetchError('User not found'));
        return;
      }

      final items = await getItemsUsecase(id: id);

      emit(ItemFetchLoaded(items));
    } catch (e) {
      emit(ItemFetchError(e.toString()));
    }
  }
}
