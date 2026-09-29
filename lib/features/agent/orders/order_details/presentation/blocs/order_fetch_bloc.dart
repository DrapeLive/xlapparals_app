import 'package:dio/dio.dart';
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
      // Guard against a second tap landing before the button rebuilds with
      // placingOrder: true. onPressed being nulled in the UI is not enough,
      // the emit below only reaches the widget tree on the next frame.
      if (state.placingOrder) return;

      try {
        emit(state.copyWith(placingOrder: true));

        // Transport "None" is represented by a sentinel with id == 0.
        // When untouched, fall back to the order's already-saved values so
        // placing never wipes the existing delivery option/date.
        final selected = state.selectedTransport;
        final transportId = selected == null
            ? state.order?.preferredTransport
            : (selected.id == 0 ? null : selected.id);

        await repository.placeOrder(
          orderId: event.orderId,
          expectedDate: state.expectedDate ?? state.order?.expectedDeliveryDate,
          transportId: transportId,
        );

        emit(state.copyWith(placingOrder: false, placeOrderSuccess: true));
      } on DioException catch (e) {
        emit(
          state.copyWith(
            placingOrder: false,
            placeOrderSuccess: false,
            error: _readPlaceOrderError(e),
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            placingOrder: false,
            placeOrderSuccess: false,
            error: e.toString(),
          ),
        );
      }
    });
  }

  // The place-order endpoint answers 400 with { error, out_of_stock_items }.
  // Show the server's own wording when present, it is far clearer than a
  // raw DioException string.
  String _readPlaceOrderError(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['error'] is String) {
      final message = (data['error'] as String).trim();
      if (message.isNotEmpty) return message;
    }

    return e.toString();
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
    try {
      emit(state.copyWith(status: OrderDetailsStatus.loading));
      await repository.deleteItemOrder(
        orderId: event.orderId,
        itemId: event.itemId,
      );
      add(FetchOrderDetails(event.orderId));
    } catch (_) {
      add(FetchOrderDetails(event.orderId));
    }
  }
}
