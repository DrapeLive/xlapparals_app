import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/customer.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

enum CustomerStatus { initial, loading, success, failure }

class CustomerState {
  final CustomerStatus status;
  final List<Customer> customers;
  final bool hasReachedMax;
  final String search;
  final bool isCreating;
  final bool createSuccess;
  final String? createError;
  final List<Transport> transports;
  final bool isLoadingTransports;

  const CustomerState({
    this.status = CustomerStatus.initial,
    this.customers = const [],
    this.hasReachedMax = false,
    this.search = '',
    this.isCreating = false,
    this.createSuccess = false,
    this.createError,
    this.transports = const [],
    this.isLoadingTransports = false,
  });

  CustomerState copyWith({
    CustomerStatus? status,
    List<Customer>? customers,
    bool? hasReachedMax,
    String? search,
    bool? isCreating,
    bool? createSuccess,
    String? createError,
    List<Transport>? transports,
    bool? isLoadingTransports,
  }) {
    return CustomerState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      search: search ?? this.search,
      isCreating: isCreating ?? this.isCreating,
      createSuccess: createSuccess ?? this.createSuccess,
      createError: createError,
      transports: transports ?? this.transports,
      isLoadingTransports: isLoadingTransports ?? this.isLoadingTransports,
    );
  }
}
