import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/customer_detals.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

import 'agent_details.dart';

class OrderDetails {
  final int id;

  final List<OrderItem> items;

  final AgentDetails agentDetails;

  final CustomerDetails customerDetails;

  final int totalSets;
  final int totalPieces;

  final String status;

  final String? expectedDeliveryDate;

  final String? preferredTransport;

  final String? transportCompany;

  const OrderDetails({
    required this.id,
    required this.items,
    required this.agentDetails,
    required this.customerDetails,
    required this.totalSets,
    required this.totalPieces,
    required this.status,
    required this.expectedDeliveryDate,
    required this.preferredTransport,
    required this.transportCompany,
  });

  bool get isDraft => status.toUpperCase() == "DRAFT";

  bool get isPending => status.toUpperCase() == "PENDING";

  bool get hasItems => items.isNotEmpty;

  double get grandTotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }
}
