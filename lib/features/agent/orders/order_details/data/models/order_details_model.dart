import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';

import 'agent_details_model.dart';
import 'customer_details_model.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends OrderDetails {
  OrderDetailsModel({
    required super.id,
    required super.items,
    required super.agentDetails,
    required super.customerDetails,
    required super.totalSets,
    required super.totalPieces,
    required super.status,
    required super.expectedDeliveryDate,
    required super.preferredTransport,
    required super.transportCompany,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json["id"],

      items: (json["items"] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),

      agentDetails: AgentDetailsModel.fromJson(json["agent_details"]),

      customerDetails: CustomerDetailsModel.fromJson(json["customer_details"]),

      totalSets: json["total_sets"] ?? 0,

      totalPieces: json["total_pieces"] ?? 0,

      status: json["status"] ?? "",

      expectedDeliveryDate: json["expected_delivery_date"],

      preferredTransport: json["preferred_transport"],

      transportCompany: json["transport_company"],
    );
  }
}
