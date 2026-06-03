import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';

class Item {
  final int id;
  final String name;
  final String type;
  final String price;
  final List<Variant> variants;

  const Item({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.variants,
  });
}
