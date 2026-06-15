import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

abstract class OrderDetailsEvent {}

class FetchOrderDetails extends OrderDetailsEvent {
  final int orderId;

  FetchOrderDetails(this.orderId);
}

class RefreshOrderDetails extends OrderDetailsEvent {
  final int orderId;

  RefreshOrderDetails(this.orderId);
}

class PickDeliveryDate extends OrderDetailsEvent {
  final DateTime date;

  PickDeliveryDate(this.date);
}

class LoadTransports extends OrderDetailsEvent {}

class SelectTransport extends OrderDetailsEvent {
  final Transport transport;

  SelectTransport(this.transport);
}

class PlaceOrder extends OrderDetailsEvent {
  final int orderId;

  PlaceOrder(this.orderId);
}

class StartEditOrder extends OrderDetailsEvent {
  final int orderId;

  StartEditOrder(this.orderId);
}

class DeleteOrder extends OrderDetailsEvent {
  final int orderId;

  DeleteOrder(this.orderId);
}

class DeleteOrderItem extends OrderDetailsEvent {
  final int orderId;
  final int itemId;
  DeleteOrderItem(this.orderId, this.itemId);
}
