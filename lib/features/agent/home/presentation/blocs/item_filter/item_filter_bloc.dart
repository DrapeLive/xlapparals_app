import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/core/utils/size_utils.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';

part 'item_filter_event.dart';
part 'item_filter_state.dart';

class ItemFilterBloc extends Bloc<ItemFilterEvent, ItemFilterState> {
  ItemFilterBloc() : super(const ItemFilterState()) {
    on<ItemFilterTabChanged>(_onTabChanged);
    on<ItemFilterSearchChanged>(_onSearchChanged);
    on<ItemFilterCleared>(_onCleared);
  }

  void _onTabChanged(
    ItemFilterTabChanged event,
    Emitter<ItemFilterState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  void _onSearchChanged(
    ItemFilterSearchChanged event,
    Emitter<ItemFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onCleared(ItemFilterCleared event, Emitter<ItemFilterState> emit) {
    emit(const ItemFilterState());
  }
}

List<Item> filterItems({
  required List<Item> items,
  required StockTab tab,
  required String searchQuery,
}) {
  List<Item> filtered = List.from(items);

  if (tab == StockTab.inStock) {
    filtered = filtered.where((item) => !isItemOutOfStock(item)).toList();
    filtered = filtered.map((item) {
      final inStockVariants = item.variants
          .where((v) => !isVariantOutOfStock(v, item.type))
          .toList();
      return item.copyWith(variants: inStockVariants);
    }).toList();
  } else {
    filtered = filtered
        .where(
          (item) =>
              isItemOutOfStock(item) ||
              item.variants.any((v) => isVariantOutOfStock(v, item.type)),
        )
        .toList();
    filtered = filtered.map((item) {
      final outVariants = item.variants
          .where((v) => isVariantOutOfStock(v, item.type))
          .toList();
      return item.copyWith(variants: outVariants);
    }).toList();
  }

  if (searchQuery.trim().isNotEmpty) {
    final q = searchQuery.toLowerCase();
    filtered = filtered
        .where((item) => item.name.toLowerCase().contains(q))
        .toList();
  }

  return filtered;
}

bool isItemOutOfStock(Item item) {
  return item.variants.every((v) => isVariantOutOfStock(v, item.type));
}

bool isVariantOutOfStock(Variant variant, String itemType) {
  final sizeRanges = SizeRangeUtils.getSizeRangesWithStock(variant, itemType);
  if (sizeRanges.isEmpty) return true;
  return sizeRanges.every((s) => s.stock == 0);
}
