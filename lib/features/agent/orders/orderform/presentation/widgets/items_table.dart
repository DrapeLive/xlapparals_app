import 'package:intl/intl.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';
import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class ItemsTable extends StatelessWidget {
  final OrderInvoice invoice;

  ItemsTable(this.invoice);

  final formattedAmount = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(1.8),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(3),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: AppColors.primary),
          children: [
            Center(
              child: Text(
                "Item",
                style: TextStyle(color: AppColors.secondary, fontSize: 11),
              ),
            ),
            Center(
              child: Text(
                "Size",
                style: TextStyle(color: AppColors.secondary, fontSize: 11),
              ),
            ),
            Center(
              child: Text(
                "Price",
                style: TextStyle(color: AppColors.secondary, fontSize: 11),
              ),
            ),
            Center(
              child: Text(
                "Qty",
                style: TextStyle(color: AppColors.secondary, fontSize: 11),
              ),
            ),
            Center(
              child: Text(
                "Amount",
                style: TextStyle(color: AppColors.secondary, fontSize: 11),
              ),
            ),
          ],
        ),

        ...invoice.items.map(
          (item) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(item.itemName, style: TextStyle(fontSize: 10)),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(item.sizeGroup, style: TextStyle(fontSize: 10)),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  "₹${item.itemPrice}",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  "${item.quantity} x ${item.pieceCount}",
                  style: TextStyle(fontSize: 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  formattedAmount.format(
                    (double.tryParse(item.itemPrice) ?? 0) *
                        item.quantity *
                        item.pieceCount,
                  ),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
