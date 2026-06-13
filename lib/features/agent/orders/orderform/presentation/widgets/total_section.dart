import 'package:flutter/material.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class TotalsSection extends StatelessWidget {
  final OrderInvoice invoice;

  const TotalsSection(this.invoice);

  @override
  Widget build(BuildContext context) {
    final gst = invoice.totalPrice * invoice.gstRate / 100;

    final grandTotal = invoice.totalPrice + gst;

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "TOTAL PIECES: ${invoice.items.fold(0, (sum, item) => sum + (item.quantity * item.pieceCount))}",
          ),

          Text("SUBTOTAL: ₹${invoice.totalPrice}"),

          Text("GST @ ${invoice.gstRate}% : ₹$gst"),

          const SizedBox(height: 10),

          Text(
            "TOTAL : ₹$grandTotal",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
