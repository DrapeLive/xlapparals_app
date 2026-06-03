import 'package:equatable/equatable.dart';

abstract class ItemFetchEvent extends Equatable {
  const ItemFetchEvent();

  @override
  List<Object?> get props => [];
}

class FetchItems extends ItemFetchEvent {}
