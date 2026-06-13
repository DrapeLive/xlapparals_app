import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/customer_response.dart';

abstract class CustomerRepository {
  Future<CustomerResponse> getCustomers({
    required int page,
    String search = '',
  });
}
