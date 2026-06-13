import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

enum OrderDetailsStatus { initial, loading, success, failure }

class OrderDetailsState {
  final OrderDetailsStatus status;
  final OrderDetails? order;
  final String? error;
  final DateTime? expectedDate;
  final Transport? selectedTransport;
  final List<Transport> transports;
  final bool loadingTransports;
  final bool placingOrder;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.initial,
    this.order,
    this.error,
    this.expectedDate,
    this.selectedTransport,
    this.transports = const [],
    this.loadingTransports = false,
    this.placingOrder = false,
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    OrderDetails? order,
    String? error,
    DateTime? expectedDate,
    Transport? selectedTransport,
    List<Transport>? transports,
    bool? loadingTransports,
    bool? placingOrder,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      error: error,
      expectedDate: expectedDate ?? this.expectedDate,
      selectedTransport: selectedTransport ?? this.selectedTransport,
      transports: transports ?? this.transports,
      loadingTransports: loadingTransports ?? this.loadingTransports,
      placingOrder: placingOrder ?? this.placingOrder,
    );
  }
}
