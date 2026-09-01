import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/customer_response.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class CustomerRepository {
  Future<CustomerResponse> getCustomers({
    required int page,
    String search = '',
  });

  Future<void> createCustomer(Map<String, dynamic> data);
  Future<List<Transport>> getTransports();
}
