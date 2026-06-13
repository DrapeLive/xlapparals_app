import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/size_range.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/variant.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';

class SizeRangeUtils {
  static List<SizeRange> getSizeRangesWithStock(
    Variant variant,
    String itemType,
  ) {
    final result = <SizeRange>[];
    final sizeMap = {
      for (final size in variant.sizeRanges) size.sizeRange: size.stock,
    };

    final allowedRanges = AppConstants.orderCreationSizesByType[itemType] ?? [];

    for (final range in allowedRanges) {
      final groupedSizes = AppConstants.sizeRangeToSizes[range] ?? [];

      final matched = groupedSizes
          .where((size) => sizeMap.containsKey(size))
          .toList();

      if (matched.isEmpty) continue;

      if (matched.length != groupedSizes.length) continue;

      final stocks = groupedSizes.map((size) => sizeMap[size]!).toList();

      final minStock = stocks.reduce((a, b) => a < b ? a : b);

      result.add(SizeRange(sizeRange: range, stock: minStock));
    }

    if (itemType == "gents") {
      if (result.isEmpty) return [];

      result.sort(
        (a, b) =>
            (AppConstants.sizeRangeToSizes[b.sizeRange]?.length ?? 0) -
            (AppConstants.sizeRangeToSizes[a.sizeRange]?.length ?? 0),
      );

      return [result.first];
    }

    return result;
  }

  static List<ItemSize> getAvailableSizes({
    required List<ItemSize> variantSizes,
    required String itemType,
  }) {
    final availableRanges =
        AppConstants.orderCreationSizesByType[itemType] ?? <String>[];

    final variantSizeNames = variantSizes.map((e) => e.sizeRange).toSet();

    if (itemType == "gents") {
      for (final range in availableRanges) {
        final rangeSizes = AppConstants.sizeRangeToSizes[range] ?? [];

        final rangeSet = rangeSizes.toSet();

        final exactMatch =
            rangeSet.length == variantSizeNames.length &&
            rangeSet.every((size) => variantSizeNames.contains(size));

        if (exactMatch) {
          return [ItemSize(id: 0, sizeRange: range, stock: 0)];
        }
      }

      return variantSizes;
    }

    return availableRanges
        .where((range) {
          final requiredSizes = AppConstants.sizeRangeToSizes[range] ?? [];

          return requiredSizes.every((size) => variantSizeNames.contains(size));
        })
        .map((range) => ItemSize(id: 0, sizeRange: range, stock: 0))
        .toList();
  }
}
