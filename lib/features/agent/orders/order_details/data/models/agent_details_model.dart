import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/agent_details.dart';

class AgentDetailsModel extends AgentDetails {
  AgentDetailsModel({
    required super.id,
    required super.username,
    required super.contact,
  });

  factory AgentDetailsModel.fromJson(Map<String, dynamic> json) {
    return AgentDetailsModel(
      id: json["id"] ?? 0,
      username: json["username"]?.toString() ?? "",
      contact: json["contact"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "username": username, "contact": contact};
  }
}
