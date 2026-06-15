import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/models/order_details_model.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class EditOrderRemoteDatasource {
  Future<OrderDetailsModel> getOrderDetails(int orderId);

  Future<List<Transport>> getTransports();

  Future<void> saveEditOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  });

  Future<void> deleteItem({required int orderId, required int itemId});
}

class EditOrderRemoteDataSourceImpl extends EditOrderRemoteDatasource {
  final Dio dio;

  EditOrderRemoteDataSourceImpl(this.dio);

  @override
  Future<void> saveEditOrder({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  }) async {
    await dio.post(
      '/orders/$orderId/save-edit/',
      data: {
        "expected_delivery_date": expectedDate
            ?.toIso8601String()
            .split('T')
            .first,
        "preferred_transport": transportId,
      },
    );
  }

  @override
  Future<void> deleteItem({required int orderId, required int itemId}) async {
    await dio.delete('/orders/$orderId/delete-item/$itemId/');
  }

  @override
  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    final response = await dio.get("/orders/$orderId/");
    final data = OrderDetailsModel.fromJson(response.data);
    return data;
  }

  @override
  Future<List<Transport>> getTransports() async {
    final response = await dio.get('/transports/active/');

    return (response.data as List)
        .map((e) => Transport(id: e['id'], name: e['name']))
        .toList();
  }
}
