import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/item_detals.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';

class ItemDetailsState {
  final bool isLoading;
  final bool isAdding;

  final ItemDetails? item;

  final int selectedVariantIndex;

  final List<ItemSize> availableSizes;
  final ItemSize? selectedSize;

  final int quantity;

  final bool addedSuccessfully;
  final String? error;

  const ItemDetailsState({
    this.isLoading = false,
    this.isAdding = false,
    this.item,
    this.selectedVariantIndex = 0,
    this.availableSizes = const [],
    this.selectedSize,
    this.quantity = 1,
    this.addedSuccessfully = false,
    this.error,
  });

  ItemDetailsState copyWith({
    bool? isLoading,
    bool? isAdding,
    ItemDetails? item,
    int? selectedVariantIndex,
    List<ItemSize>? availableSizes,
    ItemSize? selectedSize,
    int? quantity,
    bool? addedSuccessfully,
    String? error,
  }) {
    return ItemDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      item: item ?? this.item,
      selectedVariantIndex: selectedVariantIndex ?? this.selectedVariantIndex,
      availableSizes: availableSizes ?? this.availableSizes,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      addedSuccessfully: addedSuccessfully ?? this.addedSuccessfully,
      error: error,
    );
  }
}
