import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/variant.dart';

class ItemDetails {
  final int id;
  final String name;
  final double price;
  final String type;
  final String description;
  final List<Variant> variants;
  final int matchedVariantId;

  const ItemDetails({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.description,
    required this.variants,
    required this.matchedVariantId,
  });
}
