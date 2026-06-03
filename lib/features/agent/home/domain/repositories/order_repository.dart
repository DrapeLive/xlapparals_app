import '../entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders();
}
