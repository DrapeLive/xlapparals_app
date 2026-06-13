import 'package:xlapparals_app/features/agent/orders/customers/data/datasources/customer_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/models/customer_response.dart';

import '../../domain/repository/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerResponseModel> getCustomers({
    required int page,
    String search = '',
  }) async {
    return await remoteDataSource.getCustomers(page: page, search: search);
  }
}
