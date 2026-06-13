import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/item_detals.dart';

import '../repositories/add_item_repository.dart';

class GetItemByQrUseCase {
  final AddItemRepository repository;

  GetItemByQrUseCase(this.repository);

  Future<ItemDetails> call({required String qrCode, required int agentId}) {
    return repository.getItemByQr(qrCode: qrCode, agentId: agentId);
  }
}
