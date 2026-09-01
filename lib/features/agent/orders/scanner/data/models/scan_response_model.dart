import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';

class ScanResponseModel extends ScanResponse {
  const ScanResponseModel({
    required super.outOfStock,
    required super.groupStock,
  });

  factory ScanResponseModel.fromJson(Map<String, dynamic> json) {
    bool outOfStock = false;
    Map<String, dynamic> groupStock = {};

    if (json.containsKey('variants') && json.containsKey('matched_variant_id')) {
      final variants = json['variants'] as List;
      final matchedVariantId = json['matched_variant_id'];

      final matchedVariant = variants.firstWhere(
        (v) => v['id'] == matchedVariantId,
        orElse: () => null,
      );

      if (matchedVariant != null) {
        final sizes = matchedVariant['sizes'] as List;
        int totalStock = 0;
        for (final size in sizes) {
          final sizeRange = size['size_range'] as String;
          final stock = size['stock'] as int;
          groupStock[sizeRange] = stock;
          totalStock += stock;
        }
        outOfStock = totalStock == 0;
      } else {
        outOfStock = true;
      }
    } else {
      outOfStock = json['out_of_stock'] ?? false;
      groupStock = json['group_stock'] ?? {};
    }

    return ScanResponseModel(
      outOfStock: outOfStock,
      groupStock: groupStock,
    );
  }
}
