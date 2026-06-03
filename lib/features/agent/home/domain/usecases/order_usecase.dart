import 'package:xlapparals_app/features/agent/home/domain/repositories/order_repository.dart';

import '../entities/order.dart';

class GetOrdersUseCase {
  final OrdersRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<Order>> call() {
    return repository.getOrders();
  }
}
