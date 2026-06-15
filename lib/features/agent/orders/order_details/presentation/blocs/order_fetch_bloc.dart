import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/repository/order_repository.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_state.dart';

class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderDetailsRepository repository;

  OrderDetailsBloc(this.repository) : super(const OrderDetailsState()) {
    on<StartEditOrder>(_startEdit);
    on<DeleteOrder>(_deleteOrder);
    on<DeleteOrderItem>(_deleteOrderItem);
    on<FetchOrderDetails>(_fetch);
    on<RefreshOrderDetails>(_refresh);
    on<PickDeliveryDate>((event, emit) {
      emit(state.copyWith(expectedDate: event.date));
    });
    on<SelectTransport>((event, emit) {
      emit(state.copyWith(selectedTransport: event.transport));
    });
    on<LoadTransports>((event, emit) async {
      emit(state.copyWith(loadingTransports: true));

      final transports = await repository.getActiveTransports();

      emit(state.copyWith(transports: transports, loadingTransports: false));
    });

    on<PlaceOrder>((event, emit) async {
      try {
        emit(state.copyWith(placingOrder: true));

        await repository.placeOrder(
          orderId: event.orderId,
          expectedDate: state.expectedDate,
          transportId: state.selectedTransport?.id,
        );

        emit(state.copyWith(placingOrder: false));
      } catch (e) {
        emit(state.copyWith(placingOrder: false));
      }
    });
  }

  Future<void> _fetch(
    FetchOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: OrderDetailsStatus.loading));

      final order = await repository.getOrderDetails(event.orderId);
      emit(state.copyWith(status: OrderDetailsStatus.success, order: order));
    } catch (e) {
      emit(
        state.copyWith(status: OrderDetailsStatus.failure, error: e.toString()),
      );
    }
  }

  Future<void> _refresh(
    RefreshOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    try {
      final order = await repository.getOrderDetails(event.orderId);

      emit(state.copyWith(status: OrderDetailsStatus.success, order: order));
    } catch (_) {}
  }

  Future<void> _startEdit(
    StartEditOrder event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(state.copyWith(loadingTransports: true));

    await repository.startEditOrder(event.orderId);
  }

  Future<void> _deleteOrder(
    DeleteOrder event,
    Emitter<OrderDetailsState> emit,
  ) async {
    await repository.deleteOrder(event.orderId);
  }

  Future<void> _deleteOrderItem(
    DeleteOrderItem event,
    Emitter<OrderDetailsState> emit,
  ) async {
    await repository.deleteItemOrder(
      orderId: event.orderId,
      itemId: event.itemId,
    );
  }
}
