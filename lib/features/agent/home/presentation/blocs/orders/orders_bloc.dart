import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/order_usecase.dart';

import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersBloc(this.getOrdersUseCase) : super(OrdersInitial()) {
    on<FetchOrders>(_fetchOrders);
  }

  Future<void> _fetchOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    try {
      final orders = await getOrdersUseCase();

      emit(OrdersLoaded(orders));
    } on DioException catch (e) {
      emit(OrdersError(e.message ?? "Failed to fetch orders"));
    } catch (_) {
      emit(OrdersError("Something went wrong"));
    }
  }
}
