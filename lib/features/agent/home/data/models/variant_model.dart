import 'package:xlapparals_app/features/agent/home/data/models/size_range_model.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';

class VariantModel extends Variant {
  VariantModel({
    required super.id,
    required super.image,
    required super.qrCode,
    required super.createdAt,
    required super.sizeRanges,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'],
      image: json['image'],
      qrCode: json['qr_code'],
      createdAt: DateTime.parse(json['created_at']),
      sizeRanges: (json['size_ranges'] as List)
          .map((e) => SizeRangeModel.fromJson(e))
          .toList(),
    );
  }
}
