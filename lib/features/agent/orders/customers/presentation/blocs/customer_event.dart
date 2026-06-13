abstract class CustomerEvent {}

class FetchCustomers extends CustomerEvent {}

class LoadMoreCustomers extends CustomerEvent {}

class SearchCustomers extends CustomerEvent {
  final String query;

  SearchCustomers(this.query);
}
