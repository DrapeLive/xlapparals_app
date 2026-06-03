import 'package:xlapparals_app/features/agent/home/domain/entities/size_range.dart';

class Variant {
  final int id;
  final String image;
  final String qrCode;
  final DateTime createdAt;
  final List<SizeRange> sizeRanges;

  const Variant({
    required this.id,
    required this.image,
    required this.qrCode,
    required this.createdAt,
    required this.sizeRanges,
  });
}
