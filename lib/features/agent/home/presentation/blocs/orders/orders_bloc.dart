import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/cache/api_cache_service.dart';
import 'package:xlapparals_app/features/agent/home/domain/usecases/order_usecase.dart';

import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final ApiCacheService apiCache;

  OrdersBloc(this.getOrdersUseCase, this.apiCache) : super(OrdersInitial()) {
    on<FetchOrders>(_fetchOrders);
  }

  Future<void> _fetchOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    // A user-initiated refresh must reach the network, so drop any cached copy.
    if (event.forceRefresh) {
      apiCache.invalidatePrefix('/orders/');
    } else if (state is! OrdersLoaded) {
      // Stale-while-revalidate: render the last known-good list instantly.
      final cached = await getOrdersUseCase.getCached();
      if (cached != null && cached.isNotEmpty) {
        emit(OrdersLoaded(cached, isFromCache: true));
      }
    }

    // Only show a loader when we truly have nothing to paint yet.
    if (state is! OrdersLoaded) {
      emit(OrdersLoading());
    }

    try {
      final orders = await getOrdersUseCase();

      emit(OrdersLoaded(orders));
    } on DioException catch (e) {
      // Keep showing whatever we already painted (fresh or cached).
      if (state is OrdersLoaded) return;
      emit(OrdersError(e.message ?? "Failed to fetch orders"));
    } catch (_) {
      if (state is OrdersLoaded) return;
      emit(OrdersError("Something went wrong"));
    }
  }
}