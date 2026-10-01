import 'package:equatable/equatable.dart';

abstract class ItemFetchEvent extends Equatable {
  const ItemFetchEvent();

  @override
  List<Object?> get props => [];
}

class FetchItems extends ItemFetchEvent {
  final bool forceRefresh;

  const FetchItems({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}