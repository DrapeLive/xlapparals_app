import 'package:xlapparals_app/features/agent/home/domain/entities/size_range.dart';

class SizeRangeModel extends SizeRange {
  SizeRangeModel({required super.sizeRange, required super.stock});

  factory SizeRangeModel.fromJson(Map<String, dynamic> json) {
    return SizeRangeModel(sizeRange: json['size_range'], stock: json['stock']);
  }

  Map<String, dynamic> toJson() {
    return {'size_range': sizeRange, 'stock': stock};
  }
}
