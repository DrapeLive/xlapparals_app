import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';

import 'agent_details_model.dart';
import 'customer_details_model.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends OrderDetails {
  OrderDetailsModel({
    required super.createdAt,
    required super.lrNumber,
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
      id: json["id"] ?? 0,

      items: (json["items"] as List? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),

      agentDetails: AgentDetailsModel.fromJson(
        json["agent_details"] as Map<String, dynamic>? ?? {},
      ),

      customerDetails: CustomerDetailsModel.fromJson(
        json["customer_details"] as Map<String, dynamic>? ?? {},
      ),

      totalSets: json["total_sets"] ?? 0,

      totalPieces: json["total_pieces"] ?? 0,

      status: json["status"]?.toString() ?? "",

      lrNumber: json["lr_number"]?.toString() ?? "",

      expectedDeliveryDate: json["expected_delivery_date"] == null
          ? null
          : DateTime.tryParse(json["expected_delivery_date"].toString()),

      // API returns:
      // "preferred_transport": null
      preferredTransport: json["preferred_transport"] is int
          ? json["preferred_transport"]
          : int.tryParse(json["preferred_transport"]?.toString() ?? ""),

      // API returns:
      // "transport_company": null
      transportCompany: json["transport_company"]?.toString(),

      createdAt:
          DateTime.tryParse(json["created_at"]?.toString() ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
