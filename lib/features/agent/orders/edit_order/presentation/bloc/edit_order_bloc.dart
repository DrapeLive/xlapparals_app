import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/domain/repositories/edit_order_repository.dart';

import 'edit_order_event.dart';
import 'edit_order_state.dart';

class EditOrderBloc extends Bloc<EditOrderEvent, EditOrderState> {
  final EditOrderRepository repository;

  EditOrderBloc(this.repository) : super(const EditOrderState()) {
    on<SaveEditOrder>(_saveEdit);

    on<SelectEditTransport>((event, emit) {
      emit(state.copyWith(transport: event.transport));
    });

    on<PickEditDeliveryDate>((event, emit) {
      emit(state.copyWith(expectedDate: event.date));
    });

    on<DeleteItemEvent>(_deleteItem);

    on<FetchEditOrderDetails>(_fetch);
    on<RefreshOrderDetails>(_refresh);
    on<LoadTransports>((event, emit) async {
      emit(state.copyWith(loadingTransports: true));

      final transports = await repository.getActiveTransports();

      emit(state.copyWith(transports: transports, loadingTransports: false));
    });
  }

  Future<void> _saveEdit(
    SaveEditOrder event,
    Emitter<EditOrderState> emit,
  ) async {
    emit(state.copyWith(saving: true));

    await repository.saveEditOrder(
      orderId: event.orderId,
      expectedDate: state.expectedDate,
      transportId: state.transport?.id,
    );

    emit(state.copyWith(saving: false));
  }

  Future<void> _fetch(
    FetchEditOrderDetails event,
    Emitter<EditOrderState> emit,
  ) async {
    try {
      final order = await repository.getOrderDetails(event.orderId);
      emit(state.copyWith(order: order));
    } catch (e) {
      // Implement Future
    }
  }

  Future<void> _refresh(
    RefreshOrderDetails event,
    Emitter<EditOrderState> emit,
  ) async {
    try {
      final order = await repository.getOrderDetails(event.orderId);

      emit(state.copyWith(order: order));
    } catch (_) {}
  }

  Future<void> _deleteItem(
    DeleteItemEvent event,
    Emitter<EditOrderState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true));
      await repository.deleteItem(itemId: event.itemId, orderId: event.orderId);

      emit(state.copyWith(loading: false));
    } catch (_) {}
  }
}
