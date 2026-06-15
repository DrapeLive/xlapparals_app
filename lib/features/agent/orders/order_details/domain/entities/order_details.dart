import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/customer_detals.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

import 'agent_details.dart';

class OrderDetails {
  final int id;

  final List<OrderDetailsItem> items;

  final AgentDetails agentDetails;

  final CustomerDetails customerDetails;

  final int totalSets;
  final int totalPieces;

  final String status;

  final DateTime? expectedDeliveryDate;

  final String lrNumber;

  final int? preferredTransport;

  final String? transportCompany;

  final DateTime createdAt;

  const OrderDetails({
    required this.createdAt,
    required this.id,
    required this.items,
    required this.agentDetails,
    required this.customerDetails,
    required this.lrNumber,
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
