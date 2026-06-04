part of 'item_filter_bloc.dart';

abstract class ItemFilterEvent extends Equatable {
  const ItemFilterEvent();

  @override
  List<Object?> get props => [];
}

class ItemFilterTabChanged extends ItemFilterEvent {
  final StockTab tab;
  const ItemFilterTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ItemFilterSearchChanged extends ItemFilterEvent {
  final String query;
  const ItemFilterSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ItemFilterCleared extends ItemFilterEvent {
  const ItemFilterCleared();
}
