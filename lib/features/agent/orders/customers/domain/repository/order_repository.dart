import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/order_response.dart';

abstract class CreateOrderRepository {
  Future<CreateOrderResponse> createOrder({
    required int customerId,
    required int agentId,
  });
}
