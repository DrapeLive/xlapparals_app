abstract class CustomerEvent {}

class FetchCustomers extends CustomerEvent {}

class LoadMoreCustomers extends CustomerEvent {}

class SearchCustomers extends CustomerEvent {
  final String query;

  SearchCustomers(this.query);
}

class FetchTransports extends CustomerEvent {}

class CreateCustomer extends CustomerEvent {
  final Map<String, dynamic> data;

  CreateCustomer(this.data);
}
