import '../entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders();

  Future<List<Order>?> getCachedOrders();
}
