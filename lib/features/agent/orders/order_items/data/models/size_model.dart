import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';

class SizeModel extends ItemSize {
  const SizeModel({
    required super.id,
    required super.sizeRange,
    required super.stock,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      sizeRange: json['size_range'],
      stock: json['stock'],
    );
  }
}
