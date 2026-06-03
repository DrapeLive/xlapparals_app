import 'package:xlapparals_app/features/agent/home/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.itemPrice,
    required super.quantity,
    required super.pieceCount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      itemPrice: double.parse(json["item_price"]),
      quantity: json["quantity"],
      pieceCount: json["piece_count"] ?? 1,
    );
  }
}
