import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

import '../entities/order_details.dart';

abstract class OrderDetailsRepository {
  Future<OrderDetails> getOrderDetails(int orderId);
  Future<List<Transport>> getActiveTransports();
  Future<void> placeOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  });
}
