import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/order_response.dart';

enum CreateOrderStatus { initial, loading, success, failure }

class CreateOrderState {
  final CreateOrderStatus status;
  final CreateOrderResponse? order;
  final String? error;

  const CreateOrderState({
    this.status = CreateOrderStatus.initial,
    this.order,
    this.error,
  });

  CreateOrderState copyWith({
    CreateOrderStatus? status,
    CreateOrderResponse? order,
    String? error,
  }) {
    return CreateOrderState(
      status: status ?? this.status,
      order: order ?? this.order,
      error: error,
    );
  }
}
