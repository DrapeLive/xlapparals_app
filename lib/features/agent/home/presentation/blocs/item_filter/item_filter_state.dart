part of 'item_filter_bloc.dart';

enum StockTab { inStock, outOfStock }

class ItemFilterState extends Equatable {
  final StockTab activeTab;
  final String searchQuery;
  final int? exactItemId;
  final String? highlightVariantQrCode;

  const ItemFilterState({
    this.activeTab = StockTab.inStock,
    this.searchQuery = '',
    this.exactItemId,
    this.highlightVariantQrCode,
  });

  bool get hasActiveFilters => searchQuery.isNotEmpty;

  ItemFilterState copyWith({
    StockTab? activeTab,
    String? searchQuery,
    int? exactItemId,
    String? highlightVariantQrCode,
    bool clearQrTarget = false,
  }) {
    return ItemFilterState(
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      exactItemId: clearQrTarget ? null : (exactItemId ?? this.exactItemId),
      highlightVariantQrCode: clearQrTarget
          ? null
          : (highlightVariantQrCode ?? this.highlightVariantQrCode),
    );
  }

  @override
  List<Object?> get props => [activeTab, searchQuery, exactItemId, highlightVariantQrCode];
}
