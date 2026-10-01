abstract class OrdersEvent {
  const OrdersEvent();
}

class FetchOrders extends OrdersEvent {
  final bool forceRefresh;

  const FetchOrders({this.forceRefresh = false});
}