import 'customer.dart';

class CustomerResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Customer> results;

  CustomerResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
}
