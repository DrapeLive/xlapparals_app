import 'package:xlapparals_app/features/agent/orders/customers/data/models/customer_model.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/customer_response.dart';

class CustomerResponseModel extends CustomerResponse {
  CustomerResponseModel({
    required super.count,
    required super.next,
    required super.previous,
    required super.results,
  });

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerResponseModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => CustomerModel.fromJson(e))
          .toList(),
    );
  }
}
