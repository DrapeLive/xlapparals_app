import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class CustomerSection extends StatelessWidget {
  final OrderInvoice invoice;

  const CustomerSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final customer = invoice.customer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CUSTOMER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          customer.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 4),

        Text(customer.address, style: TextStyle(color: AppColors.primary)),

        const SizedBox(height: 4),

        Text(customer.contact, style: TextStyle(color: AppColors.primary)),

        if (customer.gst.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "GST : ${customer.gst}",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}
