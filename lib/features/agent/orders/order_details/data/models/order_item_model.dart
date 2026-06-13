import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.id,
    required super.item,
    required super.variant,
    required super.itemName,
    required super.itemPrice,
    required super.variantImage,
    required super.sizeGroup,
    required super.itemType,
    required super.quantity,
    required super.pieceCount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"],
      item: json["item"],
      variant: json["variant"],

      itemName: json["item_name"] ?? "",
      itemPrice: json["item_price"] ?? "0",

      variantImage: json["variant_image"] ?? "",

      sizeGroup: json["size_group"] ?? "",

      itemType: json["item_type"] ?? "",

      quantity: json["quantity"] ?? 0,

      pieceCount: json["piece_count"] ?? 0,
    );
  }
}
