import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/repository/customer_repository.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;

  int page = 1;

  CustomerBloc(this.repository) : super(const CustomerState()) {
    on<FetchCustomers>(_fetchCustomers);
    on<LoadMoreCustomers>(_loadMore);
    on<SearchCustomers>(_searchCustomers);
  }

  Future<void> _fetchCustomers(
    FetchCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    emit(state.copyWith(status: CustomerStatus.loading));

    final response = await repository.getCustomers(page: 1, search: '');

    emit(
      state.copyWith(
        status: CustomerStatus.success,
        customers: response.results,
        hasReachedMax: response.next == null,
      ),
    );
  }

  Future<void> _loadMore(
    LoadMoreCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    if (state.hasReachedMax) return;

    page++;

    final response = await repository.getCustomers(
      page: page,
      search: state.search,
    );

    emit(
      state.copyWith(
        customers: [...state.customers, ...response.results],
        hasReachedMax: response.next == null,
      ),
    );
  }

  Future<void> _searchCustomers(
    SearchCustomers event,
    Emitter<CustomerState> emit,
  ) async {
    page = 1;

    emit(state.copyWith(status: CustomerStatus.loading, search: event.query));

    final response = await repository.getCustomers(
      page: 1,
      search: event.query,
    );

    emit(
      state.copyWith(
        status: CustomerStatus.success,
        customers: response.results,
        hasReachedMax: response.next == null,
      ),
    );
  }
}
