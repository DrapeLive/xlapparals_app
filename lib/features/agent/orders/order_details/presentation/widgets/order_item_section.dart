import 'package:flutter/material.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

import 'empty_order_widget.dart';
import 'order_item_card.dart';

class OrderItemsSection extends StatelessWidget {
  final List<OrderItem> items;

  const OrderItemsSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyOrderWidget();
    }

    return Column(
      children: items.map((item) => OrderItemCard(item: item)).toList(),
    );
  }
}
