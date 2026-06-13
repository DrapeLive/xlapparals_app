import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/item_detals.dart';

abstract class AddItemRepository {
  Future<ItemDetails> getItemByQr({
    required String qrCode,
    required int agentId,
  });

  Future<void> addItemToOrder({
    required int orderId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  });
}
