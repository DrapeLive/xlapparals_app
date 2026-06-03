import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(const ItemState()) {
    on<ToggleItemExpansion>(_toggleExpansion);
  }

  void _toggleExpansion(ToggleItemExpansion event, Emitter<ItemState> emit) {
    final expanded = Set<String>.from(state.expandeditems);

    if (expanded.contains(event.itemId)) {
      expanded.remove(event.itemId);
    } else {
      expanded.add(event.itemId);
    }

    emit(state.copyWith(expandeditems: expanded));
  }
}
