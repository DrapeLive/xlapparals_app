import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';

class OrderInformItemCard extends StatelessWidget {
  final OrderDetailsItem item;
  final String status;

  const OrderInformItemCard(this.item, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: status == "PENDING" ? AppColors.secondary : Colors.green.shade50,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: status == "PENDING" ? AppColors.border : AppColors.green,
        ),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.variantImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == "PENDING"
                        ? AppColors.primary
                        : AppColors.green,
                  ),
                ),

                Text("Size: ${item.sizeGroup}"),

                Text("${item.quantity} Set x ${item.pieceCount} pcs"),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${item.totalPrice * item.pieceCount}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "₹${item.unitPrice}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
