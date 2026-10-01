import 'package:xlapparals_app/features/agent/home/domain/entities/size_range.dart';

class Variant {
  final int id;
  final String image;
  final String qrCode;
  final DateTime createdAt;
  final String displayOrder;
  final List<SizeRange> sizeRanges;
  final String displayOrder;

  const Variant({
    required this.id,
    required this.image,
    required this.qrCode,
    required this.createdAt,
    required this.displayOrder,
    required this.sizeRanges,
    required this.displayOrder,
  });
}
