import 'package:equatable/equatable.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';

abstract class ItemFetchState extends Equatable {
  const ItemFetchState();

  @override
  List<Object?> get props => [];
}

class ItemFetchInitial extends ItemFetchState {}

class ItemFetchLoading extends ItemFetchState {}

class ItemFetchLoaded extends ItemFetchState {
  final List<Item> items;

  const ItemFetchLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ItemFetchError extends ItemFetchState {
  final String message;

  const ItemFetchError(this.message);

  @override
  List<Object?> get props => [message];
}
