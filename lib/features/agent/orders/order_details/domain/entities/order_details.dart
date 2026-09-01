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

  /// Transport ID.
  /// Can be null because API can return null.
  final int? preferredTransport;

  /// Transport company can be null.
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

  // ---------------------------------------------------------------------------
  // Status helpers
  // ---------------------------------------------------------------------------

  bool get isDraft => status.toUpperCase() == "DRAFT";

  bool get isPending => status.toUpperCase() == "PENDING";

  bool get isDispatched => status.toUpperCase() == "DISPATCHED";

  bool get isDelivered => status.toUpperCase() == "DELIVERED";

  bool get isCancelled => status.toUpperCase() == "CANCELLED";

  // ---------------------------------------------------------------------------
  // Other helpers
  // ---------------------------------------------------------------------------

  bool get hasItems => items.isNotEmpty;

  bool get hasExpectedDeliveryDate => expectedDeliveryDate != null;

  bool get hasLrNumber => lrNumber.trim().isNotEmpty;

  bool get hasTransport =>
      preferredTransport != null ||
      (transportCompany?.trim().isNotEmpty ?? false);

  // ---------------------------------------------------------------------------
  // Calculations
  // ---------------------------------------------------------------------------

  double get grandTotal {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.unitPrice * item.quantity * item.pieceCount),
    );
  }
}
