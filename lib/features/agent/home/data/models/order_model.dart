import 'package:xlapparals_app/features/agent/home/data/models/order_item_model.dart';

import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.agentName,
    required super.id,
    required super.status,
    required super.totalSets,
    required super.totalPieces,
    required super.customerName,
    required super.createdAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      status: json["status"],
      totalSets: json["total_sets"],
      totalPieces: json["total_pieces"],
      customerName: json["customer_details"]["name"],
      items: (json["items"] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      agentName: json["agent_details"]["username"],

      createdAt: json["created_at"],
    );
  }
}
