import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
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
            style: TextStyle(color: AppColors.primary, fontSize: 12),
          ),

          Text(
            "SUBTOTAL: ₹${invoice.totalPrice}",
            style: TextStyle(color: AppColors.primary, fontSize: 12),
          ),

          Text(
            "GST @ ${invoice.gstRate}% : ₹$gst",
            style: TextStyle(color: AppColors.primary, fontSize: 12),
          ),

          const SizedBox(height: 10),

          Text(
            "TOTAL : ₹$grandTotal",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
