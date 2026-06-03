import 'package:xlapparals_app/features/agent/home/domain/entities/order_item.dart';

class Order {
  final int id;

  final List<OrderItem> items;

  final String customerName;

  final String agentName;

  final String status;

  final int totalSets;

  final int totalPieces;

  final String createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.customerName,
    required this.status,
    required this.agentName,
    required this.totalSets,
    required this.totalPieces,
    required this.createdAt,
  });

  double get totalAmount {
    return items.fold(
      0,
      (sum, item) => sum + (item.itemPrice * item.quantity * item.pieceCount),
    );
  }
}
