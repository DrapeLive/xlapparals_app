abstract class CreateOrderEvent {}

class CreateDraftOrder extends CreateOrderEvent {
  final int customerId;
  final dynamic customer;

  CreateDraftOrder({required this.customerId, required this.customer});
}
