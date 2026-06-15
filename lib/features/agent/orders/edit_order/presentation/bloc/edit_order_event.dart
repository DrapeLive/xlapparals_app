import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class EditOrderEvent {}

class SaveEditOrder extends EditOrderEvent {
  final int orderId;

  SaveEditOrder(this.orderId);
}

class SelectEditTransport extends EditOrderEvent {
  final Transport transport;

  SelectEditTransport(this.transport);
}

class PickEditDeliveryDate extends EditOrderEvent {
  final DateTime date;

  PickEditDeliveryDate(this.date);
}

class FetchEditOrderDetails extends EditOrderEvent {
  final int orderId;

  FetchEditOrderDetails(this.orderId);
}

class RefreshOrderDetails extends EditOrderEvent {
  final int orderId;

  RefreshOrderDetails(this.orderId);
}

class LoadTransports extends EditOrderEvent {}

class DeleteItemEvent extends EditOrderEvent {
  final int orderId;
  final int itemId;
  DeleteItemEvent(this.orderId, this.itemId);
}
