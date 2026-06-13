import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/item_detals.dart';

import 'variant_model.dart';

class ItemDetailsModel extends ItemDetails {
  const ItemDetailsModel({
    required super.id,
    required super.name,
    required super.price,
    required super.type,
    required super.description,
    required super.variants,
    required super.matchedVariantId,
  });

  factory ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailsModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      type: json['type'],
      description: json['description'],
      variants: (json['variants'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList(),
      matchedVariantId: json['matched_variant_id'],
    );
  }
}
