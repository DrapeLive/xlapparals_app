import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_item_order_form.dart';

class OrderItemOrderFormModel extends OrderItemOrderForm {
  const OrderItemOrderFormModel({
    required super.id,
    required super.item,
    required super.variant,
    required super.sizeGroup,
    required super.itemType,
    required super.itemName,
    required super.itemNameDisplay,
    required super.itemPrice,
    required super.itemPriceDisplay,
    required super.variantImage,
    required super.variantImageDisplay,
    required super.size,
    required super.sizeDisplay,
    required super.quantity,
    required super.packedQuantity,
    required super.pieceCount,
  });

  factory OrderItemOrderFormModel.fromJson(Map<String, dynamic> json) {
    return OrderItemOrderFormModel(
      id: json["id"],
      item: json["item"],
      variant: json["variant"],
      sizeGroup: json["size_group"] ?? "",
      itemType: json["item_type"] ?? "",
      itemName: json["item_name"] ?? "",
      itemNameDisplay: json["item_name_display"] ?? "",
      itemPrice: json["item_price"],
      itemPriceDisplay: json["item_price_display"] ?? "",
      variantImage: json["variant_image"] ?? "",
      variantImageDisplay: json["variant_image_display"],
      size: json["size"] ?? "",
      sizeDisplay: json["size_display"] ?? "",
      quantity: json["quantity"] ?? 0,
      packedQuantity: json["packed_quantity"] ?? 0,
      pieceCount: json["piece_count"] ?? 0,
    );
  }
}
