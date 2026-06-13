import 'package:flutter/material.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class AgentSection extends StatelessWidget {
  final OrderInvoice invoice;

  const AgentSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final agent = invoice.agent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "AGENT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          agent.username,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 4),

        Text(agent.contact, style: TextStyle(color: AppColors.primary)),
      ],
    );
  }
}
