import 'package:flutter/material.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/widgets/edit_order_item_card.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/empty_order_widget.dart';

class EditOrderItemsSection extends StatelessWidget {
  final List<OrderDetailsItem> items;
  final int orderId;

  const EditOrderItemsSection({
    super.key,
    required this.items,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyOrderWidget();
    }

    return Column(
      children: items
          .map((item) => EditOrderItemCard(item: item, orderId: orderId))
          .toList(),
    );
  }
}
