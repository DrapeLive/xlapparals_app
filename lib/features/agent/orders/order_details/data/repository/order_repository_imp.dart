import 'package:xlapparals_app/features/agent/orders/order_details/data/datasource/order_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/models/order_details_model.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/repository/order_repository.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDatasource remoteDatasource;

  OrderDetailsRepositoryImpl(this.remoteDatasource);

  @override
  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    final model = await remoteDatasource.getOrderDetails(orderId);
    return model;
  }

  @override
  Future<List<Transport>> getActiveTransports() async {
    final response = await remoteDatasource.getTransports();
    return response;
  }

  @override
  Future<void> placeOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  }) async {
    await remoteDatasource.placeOrderRemote(
      orderId: orderId,
      expectedDate: expectedDate,
      transportId: transportId,
    );
  }

  @override
  Future<void> startEditOrder(int orderId) async {
    await remoteDatasource.startEditOrder(orderId);
  }

  @override
  Future<void> deleteOrder(int orderId) async {
    await remoteDatasource.deleteOrder(orderId);
  }

  @override
  Future<void> deleteItemOrder({
    required int orderId,
    required int itemId,
  }) async {
    await remoteDatasource.deleteItemOrder(orderId: orderId, itemId: itemId);
  }
}
