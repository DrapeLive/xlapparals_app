import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
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
    if (orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 56,
              color: AppColors.border,
            ),
            SizedBox(height: 12),
            Text(
              'No order history yet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Dispatched, delivered and cancelled orders appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return OrderCard(
          id: order.id,
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
