import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/constants/api_constants.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/models/customer_response.dart';

abstract class CustomerRemoteDataSource {
  Future<CustomerResponseModel> getCustomers({
    required int page,
    String search = '',
  });
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
}
