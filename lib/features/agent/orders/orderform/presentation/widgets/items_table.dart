import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';
import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class ItemsTable extends StatelessWidget {
  final OrderInvoice invoice;

  const ItemsTable(this.invoice);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: AppColors.primary),
          children: [
            Center(
              child: Text("Item", style: TextStyle(color: AppColors.secondary)),
            ),
            Center(
              child: Text("Size", style: TextStyle(color: AppColors.secondary)),
            ),
            Center(
              child: Text(
                "Price",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
            Center(
              child: Text("Qty", style: TextStyle(color: AppColors.secondary)),
            ),
            Center(
              child: Text(
                "Amount",
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ],
        ),

        ...invoice.items.map(
          (item) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(item.itemName),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(item.sizeGroup),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("₹${item.itemPrice}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${item.quantity} x ${item.pieceCount}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "₹${item.itemPrice * item.quantity * item.pieceCount}",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
