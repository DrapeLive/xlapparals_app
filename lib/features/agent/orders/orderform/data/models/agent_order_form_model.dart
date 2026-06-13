import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/agent_order_form.dart';

class AgentOrderFormModel extends AgentOrderForm {
  const AgentOrderFormModel({
    required super.id,
    required super.username,
    required super.contact,
  });

  factory AgentOrderFormModel.fromJson(Map<String, dynamic> json) {
    return AgentOrderFormModel(
      id: json["id"],
      username: json["username"] ?? "",
      contact: json["contact"] ?? "",
    );
  }
}
