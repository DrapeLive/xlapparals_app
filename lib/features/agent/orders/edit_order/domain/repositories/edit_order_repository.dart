import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class EditOrderRepository {
  Future<OrderDetails> getOrderDetails(int orderId);

  Future<List<Transport>> getActiveTransports();

  Future<void> saveEditOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  });

  Future<void> deleteItem({required int orderId, required int itemId});
}
