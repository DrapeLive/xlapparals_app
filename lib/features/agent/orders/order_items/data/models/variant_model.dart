import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/variant.dart';

import 'size_model.dart';

class VariantModel extends Variant {
  const VariantModel({
    required super.id,
    required super.qrCode,
    required super.image,
    required super.sizes,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'],
      qrCode: json['qr_code'],
      image: json['image'],
      sizes: (json['sizes'] as List).map((e) => SizeModel.fromJson(e)).toList(),
    );
  }
}
