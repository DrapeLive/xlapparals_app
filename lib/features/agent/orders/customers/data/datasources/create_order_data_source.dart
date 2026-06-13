import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/models/order_response_model.dart';

abstract class CreateOrderRemoteDatasource {
  Future<CreateOrderResponseModel> createOrder({
    required int customerId,
    required int agentId,
  });
}

class CreateOrderRemoteDatasourceImpl implements CreateOrderRemoteDatasource {
  final Dio dio;

  CreateOrderRemoteDatasourceImpl(this.dio);

  @override
  Future<CreateOrderResponseModel> createOrder({
    required int customerId,
    required int agentId,
  }) async {
    final response = await dio.post(
      "/orders/",
      data: {"status": "DRAFT", "customer": customerId, "agent": agentId},
    );

    return CreateOrderResponseModel.fromJson(response.data);
  }
}
