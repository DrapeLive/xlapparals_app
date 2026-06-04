import 'package:xlapparals_app/core/utils/size_utils.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';

bool isVariantOutOfStock(Variant variant, String itemType) {
  final ranges = SizeRangeUtils.getSizeRangesWithStock(variant, itemType);
  if (ranges.isEmpty) return true;
  return ranges.every((s) => s.stock == 0);
}

bool isItemOutOfStock(Item item) {
  return item.variants.every((v) => isVariantOutOfStock(v, item.type));
}

bool isItemPartiallyOutOfStock(Item item) {
  final outCount = item.variants
      .where((v) => isVariantOutOfStock(v, item.type))
      .length;
  return outCount > 0 && outCount < item.variants.length;
}
