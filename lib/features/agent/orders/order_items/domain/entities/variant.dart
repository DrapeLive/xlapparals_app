import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';

class Variant {
  final int id;
  final String qrCode;
  final String image;
  final List<ItemSize> sizes;

  const Variant({
    required this.id,
    required this.qrCode,
    required this.image,
    required this.sizes,
  });
}
