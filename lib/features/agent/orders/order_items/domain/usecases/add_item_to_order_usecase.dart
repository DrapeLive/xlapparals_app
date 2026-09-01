import '../repositories/add_item_repository.dart';

class AddItemToOrderUseCase {
  final AddItemRepository repository;

  AddItemToOrderUseCase(this.repository);

  Future<void> call({
    required int orderId,
    required int variantId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  }) {
    return repository.addItemToOrder(
      orderId: orderId,
      variantId: variantId,
      qrCode: qrCode,
      quantity: quantity,
      sizeGroup: sizeGroup,
    );
  }
}
