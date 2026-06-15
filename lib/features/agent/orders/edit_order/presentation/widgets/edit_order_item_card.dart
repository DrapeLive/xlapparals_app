import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_event.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_items.dart';
import 'package:xlapparals_app/shared/widgets/zoom_image.dart';

class EditOrderItemCard extends StatelessWidget {
  final OrderDetailsItem item;
  final int orderId;

  const EditOrderItemCard({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditOrderBloc, EditOrderState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: AppColors.border),
            color: AppColors.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context.read<EditOrderBloc>().add(
                          DeleteItemEvent(orderId, item.id),
                        );
                        context.go(RouteNames.editOrder, extra: orderId);
                      },
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
                          fontSize: 20,
                        ),
                      ),

                      Text(
                        "${item.quantity} Set × ${item.pieceCount} pcs",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),

                Text(
                  "₹${item.itemPrice}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 18,
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
