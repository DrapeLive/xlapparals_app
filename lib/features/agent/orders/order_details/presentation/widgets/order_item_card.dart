import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_state.dart';
import 'package:xlapparals_app/shared/widgets/zoom_image.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDetailsItem item;
  final int orderId;

  const OrderItemCard({super.key, required this.item, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: AppColors.border),
            color: AppColors.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<OrderDetailsBloc>().add(
                          DeleteOrderItem(orderId, item.id),
                        );
                      },
                      icon: Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.red,
                      ),
                    ),
                  ],
                ),
                ZoomableImage(
                  imageUrl: item.variantImage,
                  height: 60,
                  width: 60,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),

                      Text(
                        "${item.quantity} Set × ${item.pieceCount} pcs",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "₹${item.itemPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
