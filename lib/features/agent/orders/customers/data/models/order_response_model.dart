import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/order_response.dart';

class CreateOrderResponseModel extends CreateOrderResponse {
  CreateOrderResponseModel({
    required super.id,
    required super.agent,
    required super.status,
  });

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponseModel(
      id: json["id"],
      agent: json["agent"],
      status: json["status"],
    );
  }
}
