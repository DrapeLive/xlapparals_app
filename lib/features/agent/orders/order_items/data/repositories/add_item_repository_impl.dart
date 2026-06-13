import 'package:xlapparals_app/features/agent/orders/order_items/data/datasources/add_item_remote_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/item_detals.dart';

import '../../domain/repositories/add_item_repository.dart';

class AddItemRepositoryImpl implements AddItemRepository {
  final AddItemRemoteDataSource remoteDataSource;

  AddItemRepositoryImpl(this.remoteDataSource);

  @override
  Future<ItemDetails> getItemByQr({
    required String qrCode,
    required int agentId,
  }) async {
    return await remoteDataSource.getItemByQr(qrCode: qrCode, agentId: agentId);
  }

  @override
  Future<void> addItemToOrder({
    required int orderId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  }) {
    return remoteDataSource.addItemToOrder(
      orderId: orderId,
      qrCode: qrCode,
      quantity: quantity,
      sizeGroup: sizeGroup,
    );
  }
}
