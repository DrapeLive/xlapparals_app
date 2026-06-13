import 'package:flutter/material.dart';
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
        const Text(
          "CUSTOMER",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 8),

        Text(
          customer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 4),

        Text(customer.address),

        const SizedBox(height: 4),

        Text(customer.contact),

        if (customer.gst.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text("GST : ${customer.gst}"),
          ),
      ],
    );
  }
}
