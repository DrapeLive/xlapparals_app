import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/customer.dart';

enum CustomerStatus { initial, loading, success, failure }

class CustomerState {
  final CustomerStatus status;
  final List<Customer> customers;
  final bool hasReachedMax;
  final String search;

  const CustomerState({
    this.status = CustomerStatus.initial,
    this.customers = const [],
    this.hasReachedMax = false,
    this.search = '',
  });

  CustomerState copyWith({
    CustomerStatus? status,
    List<Customer>? customers,
    bool? hasReachedMax,
    String? search,
  }) {
    return CustomerState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
    );
  }
}
