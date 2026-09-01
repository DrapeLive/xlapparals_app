import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/utils/size_utils.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_detail_state.dart';

import '../../domain/usecases/add_item_to_order_usecase.dart';
import '../../domain/usecases/get_item_by_qr_usecase.dart';
import 'item_details_event.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  final GetItemByQrUseCase getItemByQrUseCase;
  final AddItemToOrderUseCase addItemToOrderUseCase;

  ItemDetailsBloc(this.getItemByQrUseCase, this.addItemToOrderUseCase)
    : super(const ItemDetailsState()) {
    on<FetchItemDetails>(_fetchItem);
    on<ChangeVariant>(_changeVariant);
    on<ChangeSize>(_changeSize);
    on<IncrementQuantity>(_increment);
    on<DecrementQuantity>(_decrement);
    on<SetQuantity>(_setQuantity);
    on<AddItemToOrder>(_addToOrder);
  }

  Future<void> _fetchItem(
    FetchItemDetails event,
    Emitter<ItemDetailsState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
      addedSuccessfully: false,
      isUnassignedItem: false, // Reset the unassigned flag on a new fetch
    ));

    try {
      final item = await getItemByQrUseCase(
        qrCode: event.qrCode,
        agentId: event.agentId,
      );

      final matchedIndex = item.variants.indexWhere(
        (e) => e.id == item.matchedVariantId,
      );

      final selectedIndex = matchedIndex >= 0 ? matchedIndex : 0;

      final variant = item.variants[selectedIndex];

      final availableSizes = SizeRangeUtils.getAvailableSizes(
        variantSizes: variant.sizes,
        itemType: item.type,
      );

      final defaultSize = item.type == 'kids'
          ? SizeRangeUtils.getDefaultKidsSize(availableSizes)
          : (availableSizes.isNotEmpty ? availableSizes.first : null);

      emit(
        state.copyWith(
          isLoading: false,
          item: item,
          selectedVariantIndex: selectedIndex,
          availableSizes: availableSizes,
          selectedSize: defaultSize,
          quantity: 1, // always reset to 1 for each new item
          isUnassignedItem: false, // ensure reset
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        emit(
          state.copyWith(
            isLoading: false,
            isUnassignedItem: true,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _changeVariant(ChangeVariant event, Emitter<ItemDetailsState> emit) {
    if (state.item == null) return;

    final variant = state.item!.variants[event.index];

    final availableSizes = SizeRangeUtils.getAvailableSizes(
      variantSizes: variant.sizes,
      itemType: state.item!.type,
    );

    final defaultSize = state.item!.type == 'kids'
        ? SizeRangeUtils.getDefaultKidsSize(availableSizes)
        : (availableSizes.isNotEmpty ? availableSizes.first : null);

    emit(
      state.copyWith(
        selectedVariantIndex: event.index,
        availableSizes: availableSizes,
        selectedSize: defaultSize,
      ),
    );
  }

  void _changeSize(ChangeSize event, Emitter<ItemDetailsState> emit) {
    emit(state.copyWith(selectedSize: event.size));
  }

  void _increment(IncrementQuantity event, Emitter<ItemDetailsState> emit) {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _decrement(DecrementQuantity event, Emitter<ItemDetailsState> emit) {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void _setQuantity(SetQuantity event, Emitter<ItemDetailsState> emit) {
    final qty = event.quantity < 1 ? 1 : event.quantity;
    emit(state.copyWith(quantity: qty));
  }

  Future<void> _addToOrder(
    AddItemToOrder event,
    Emitter<ItemDetailsState> emit,
  ) async {
    if (state.item == null || state.selectedSize == null) {
      return;
    }

    if (state.quantity > state.selectedSize!.stock) {
      emit(state.copyWith(error: "Quantity exceeds available stock"));
      return;
    }

    emit(state.copyWith(isAdding: true, error: null));

    try {
      final variant = state.item!.variants[state.selectedVariantIndex];

      await addItemToOrderUseCase(
        orderId: event.orderId,
        variantId: variant.id,
        qrCode: variant.qrCode,
        quantity: state.quantity,
        sizeGroup: state.selectedSize!.sizeRange,
      );

      emit(state.copyWith(isAdding: false, addedSuccessfully: true));
    } catch (e) {
      emit(state.copyWith(isAdding: false, error: e.toString()));
    }
  }
}
