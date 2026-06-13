import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

import '../models/order_details_model.dart';
import 'package:dio/dio.dart';

abstract class OrderDetailsRemoteDatasource {
  Future<OrderDetailsModel> getOrderDetails(int orderId);
  Future<List<Transport>> getTransports();
  Future<void> placeOrderRemote({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  });
}

class OrderDetailsRemoteDatasourceImpl implements OrderDetailsRemoteDatasource {
  final Dio dio;

  OrderDetailsRemoteDatasourceImpl(this.dio);

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

  @override
  Future<void> placeOrderRemote({
    required int orderId,
    DateTime? expectedDate,
    int? transportId,
  }) async {
    await dio.post(
      '/orders/$orderId/place-order/',
      data: {
        'expected_delivery_date': expectedDate
            ?.toIso8601String()
            .split('T')
            .first,
        'preferred_transport': transportId,
      },
    );
  }
}
