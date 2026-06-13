import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/agent_order_form.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/brand_order_form.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/customer_order_form.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_item_order_form.dart';

class OrderInvoice {
  final int id;
  final CustomerOrderForm customer;
  final AgentOrderForm agent;
  final BrandOrderForm brand;
  final DateTime createdAt;
  final String status;
  final List<OrderItemOrderForm> items;
  final double totalPrice;
  final double gstRate;

  const OrderInvoice({
    required this.id,
    required this.customer,
    required this.agent,
    required this.brand,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.totalPrice,
    required this.gstRate,
  });
}
