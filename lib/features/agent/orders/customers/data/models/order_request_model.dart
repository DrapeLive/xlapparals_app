import 'package:xlapparals_app/features/agent/orders/customers/domain/entities/order_request.dart';

class CreateOrderRequestModel extends CreateOrderRequest {
  CreateOrderRequestModel({
    required super.status,
    required super.customer,
    required super.agent,
  });

  Map<String, dynamic> toJson() => {
    "status": status,
    "customer": customer,
    "agent": agent,
  };
}
