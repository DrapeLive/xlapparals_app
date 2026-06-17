import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/domain/entities/order.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  final List<Order> orders;

  const OrdersPage({super.key, required this.orders});

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                const Text(
                  "Remaining orders",
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.border,
                  ),
                  child: Text(
                    "${orders.length}",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
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
            ),
          ),
        ],
      ),
    );
  }
}
