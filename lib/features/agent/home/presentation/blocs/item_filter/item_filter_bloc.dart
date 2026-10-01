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
    on<ItemFilterQrLocated>(_onQrLocated);
    on<ItemFilterCleared>(_onCleared);
  }

  void _onTabChanged(
    ItemFilterTabChanged event,
    Emitter<ItemFilterState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab, clearQrTarget: true));
  }

  void _onSearchChanged(
    ItemFilterSearchChanged event,
    Emitter<ItemFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query, clearQrTarget: true));
  }

  void _onQrLocated(
    ItemFilterQrLocated event,
    Emitter<ItemFilterState> emit,
  ) {
    emit(state.copyWith(
      searchQuery: '',
      exactItemId: event.itemId,
      highlightVariantQrCode: event.variantQrCode,
    ));
  }

  void _onCleared(ItemFilterCleared event, Emitter<ItemFilterState> emit) {
    emit(const ItemFilterState());
  }
}

// Simple single-entry memo for [filterItems]. The Items tab rebuilds on every
// keystroke and tab tap; recomputing the filtered list only when its inputs
// actually change (by identity for the source list) avoids repeated
// list-copying + variant-copying work while keeping behaviour identical.
class _FilterMemo {
  List<Item>? source;
  StockTab? tab;
  String? query;
  int? exactItemId;
  List<Item>? result;
}

final _FilterMemo _memo = _FilterMemo();

List<Item> filterItems({
  required List<Item> items,
  required StockTab tab,
  required String searchQuery,
  int? exactItemId,
}) {
  if (identical(_memo.source, items) &&
      _memo.tab == tab &&
      _memo.query == searchQuery &&
      _memo.exactItemId == exactItemId &&
      _memo.result != null) {
    return _memo.result!;
  }

  List<Item> filtered = List.from(items);

  if (exactItemId != null) {
    filtered = filtered.where((item) => item.id == exactItemId).toList();
  } else if (tab == StockTab.inStock) {
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

  _memo
    ..source = items
    ..tab = tab
    ..query = searchQuery
    ..exactItemId = exactItemId
    ..result = filtered;

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
