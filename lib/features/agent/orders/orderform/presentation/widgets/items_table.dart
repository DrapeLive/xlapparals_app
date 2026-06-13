import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';
import 'package:flutter/material.dart';

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
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Item")),
            Padding(padding: EdgeInsets.all(8), child: Text("Size")),
            Padding(padding: EdgeInsets.all(8), child: Text("Price")),
            Padding(padding: EdgeInsets.all(8), child: Text("Qty")),
            Padding(padding: EdgeInsets.all(8), child: Text("Amount")),
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
