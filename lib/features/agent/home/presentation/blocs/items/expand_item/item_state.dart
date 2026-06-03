import 'package:equatable/equatable.dart';

class ItemState extends Equatable {
  final Set<String> expandeditems;

  const ItemState({this.expandeditems = const {}});

  ItemState copyWith({Set<String>? expandeditems}) {
    return ItemState(expandeditems: expandeditems ?? this.expandeditems);
  }

  @override
  List<Object?> get props => [expandeditems];
}
