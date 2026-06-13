abstract class CreateOrderRequest {
  final String status;
  final int customer;
  final int agent;

  CreateOrderRequest({
    required this.status,
    required this.customer,
    required this.agent,
  });
}
