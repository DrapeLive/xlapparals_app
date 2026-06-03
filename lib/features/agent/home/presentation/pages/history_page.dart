import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/order.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/order_card.dart';

class HistoryPage extends StatelessWidget {
  final List<Order> orders;

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM').format(date);
  }

  const HistoryPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return OrderCard(
          customerName: order.customerName,
          agentName: order.agentName,
          date: formatDate(order.createdAt),
          totalSets: order.totalSets,
          totalPieces: order.totalPieces,
          status: order.status,
          amount: order.totalAmount,
        );
      },
    );
  }
}
