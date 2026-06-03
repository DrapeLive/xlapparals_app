import 'package:xlapparals_app/features/agent/home/domain/repositories/order_repository.dart';

import '../../domain/entities/order.dart';

import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDatasource datasource;

  OrdersRepositoryImpl(this.datasource);

  @override
  Future<List<Order>> getOrders() async {
    final response = await datasource.getOrders();

    return response.orders;
  }
}
