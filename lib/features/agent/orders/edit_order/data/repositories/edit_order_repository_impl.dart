import 'package:xlapparals_app/features/agent/orders/edit_order/data/data_source/edit_order_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/domain/repositories/edit_order_repository.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/models/order_details_model.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

class EditOrderRepositoryImpl extends EditOrderRepository {
  final EditOrderRemoteDatasource remoteDatasource;

  EditOrderRepositoryImpl(this.remoteDatasource);

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
  Future<void> saveEditOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  }) async {
    await remoteDatasource.saveEditOrder(
      orderId: orderId,
      expectedDate: expectedDate,
      transportId: transportId,
    );
  }

  @override
  Future<void> deleteItem({required int orderId, required int itemId}) async {
    await remoteDatasource.deleteItem(orderId: orderId, itemId: itemId);
  }
}
