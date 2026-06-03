import 'package:xlapparals_app/features/agent/home/data/models/variant_model.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';

class ItemModel extends Item {
  ItemModel({
    required super.id,
    required super.name,
    required super.type,
    required super.price,
    required super.variants,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: json['price'],
      variants: (json['variants'] as List)
          .map((e) => VariantModel.fromJson(e))
          .toList(),
    );
  }
}
