import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

class OrderItemModel extends OrderDetailsItem {
  OrderItemModel({
    required super.id,
    required super.item,
    required super.variant,
    required super.itemName,
    required super.itemNameDisplay,
    required super.itemPrice,
    required super.itemPriceDisplay,
    required super.variantImage,
    super.variantImageDisplay,
    required super.sizeGroup,
    required super.itemType,
    required super.size,
    required super.sizeDisplay,
    required super.quantity,
    required super.packedQuantity,
    required super.pieceCount,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"] ?? 0,

      item: json["item"] ?? 0,

      variant: json["variant"] ?? 0,

      itemName: json["item_name"]?.toString() ?? "",

      itemNameDisplay: json["item_name_display"]?.toString() ?? "",

      itemPrice: json["item_price"]?.toString() ?? "0.00",

      itemPriceDisplay: json["item_price_display"]?.toString() ?? "0.00",

      // Nullable because API can return null.
      variantImage: json["variant_image"]?.toString(),

      variantImageDisplay: json["variant_image_display"]?.toString(),

      sizeGroup: json["size_group"]?.toString() ?? "",

      itemType: json["item_type"]?.toString() ?? "",

      size: json["size"]?.toString() ?? "",

      sizeDisplay: json["size_display"]?.toString() ?? "",

      quantity: json["quantity"] ?? 0,

      packedQuantity: json["packed_quantity"] ?? 0,

      pieceCount: json["piece_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "item": item,
      "variant": variant,
      "item_name": itemName,
      "item_name_display": itemNameDisplay,
      "item_price": itemPrice,
      "item_price_display": itemPriceDisplay,
      "variant_image": variantImage,
      "variant_image_display": variantImageDisplay,
      "size_group": sizeGroup,
      "item_type": itemType,
      "size": size,
      "size_display": sizeDisplay,
      "quantity": quantity,
      "packed_quantity": packedQuantity,
      "piece_count": pieceCount,
    };
  }
}
