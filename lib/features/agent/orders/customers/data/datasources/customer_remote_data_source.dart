import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/constants/api_constants.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/models/customer_response.dart';

import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerResponseModel> getCustomers({
    required int page,
    String search = '',
  });

  Future<void> createCustomer(Map<String, dynamic> data);
  Future<List<Transport>> getTransports();
}

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final Dio dio;

  CustomerRemoteDataSourceImpl({required this.dio});

  @override
  Future<CustomerResponseModel> getCustomers({
    required int page,
    String search = '',
  }) async {
    final response = await dio.get(
      ApiConstants.customers,
      queryParameters: {'page': page, 'search': search},
    );

    return CustomerResponseModel.fromJson(response.data);
  }

  @override
  Future<void> createCustomer(Map<String, dynamic> data) async {
    await dio.post('/customers/', data: data);
  }

  @override
  Future<List<Transport>> getTransports() async {
    final response = await dio.get('/transports/');
    return (response.data as List)
        .map((e) => Transport(id: e['id'], name: e['name']))
        .toList();
  }
}
