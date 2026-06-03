import 'package:dio/dio.dart';

import '../models/orders_response_model.dart';

abstract class OrdersRemoteDatasource {
  Future<OrdersResponseModel> getOrders();
}

class OrdersRemoteDatasourceImpl implements OrdersRemoteDatasource {
  final Dio dio;

  OrdersRemoteDatasourceImpl(this.dio);

  @override
  Future<OrdersResponseModel> getOrders() async {
    final response = await dio.get("/orders/");

    return OrdersResponseModel.fromJson(response.data);
  }
}
