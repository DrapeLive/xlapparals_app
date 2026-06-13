import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';

abstract class ItemDetailsEvent {}

class FetchItemDetails extends ItemDetailsEvent {
  final String qrCode;
  final int agentId;

  FetchItemDetails({required this.qrCode, required this.agentId});
}

class ChangeVariant extends ItemDetailsEvent {
  final int index;

  ChangeVariant(this.index);
}

class ChangeSize extends ItemDetailsEvent {
  final ItemSize size;

  ChangeSize(this.size);
}

class IncrementQuantity extends ItemDetailsEvent {}

class DecrementQuantity extends ItemDetailsEvent {}

class AddItemToOrder extends ItemDetailsEvent {
  final int orderId;

  AddItemToOrder(this.orderId);
}
