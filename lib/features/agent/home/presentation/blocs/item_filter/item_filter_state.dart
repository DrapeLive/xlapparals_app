part of 'item_filter_bloc.dart';

enum StockTab { inStock, outOfStock }

class ItemFilterState extends Equatable {
  final StockTab activeTab;
  final String searchQuery;

  const ItemFilterState({
    this.activeTab = StockTab.inStock,
    this.searchQuery = '',
  });

  bool get hasActiveFilters => searchQuery.isNotEmpty;

  ItemFilterState copyWith({StockTab? activeTab, String? searchQuery}) {
    return ItemFilterState(
      activeTab: activeTab ?? this.activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [activeTab, searchQuery];
}
