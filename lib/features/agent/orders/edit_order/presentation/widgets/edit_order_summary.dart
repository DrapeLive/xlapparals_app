import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_event.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';

class EditOrderSummaryCard extends StatelessWidget {
  final OrderDetails order;
  final int orderId;

  const EditOrderSummaryCard({
    super.key,
    required this.order,
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
            color: Colors.grey.shade100,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ORDER SUMMARY",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        "${order.totalSets} Set | ${order.totalPieces} Pcs",
                        style: TextStyle(color: AppColors.primary),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "₹${order.grandTotal.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: state.loading
                      ? null
                      : () {
                          context.read<EditOrderBloc>().add(
                            SaveEditOrder(orderId),
                          );
                          context.go(RouteNames.po, extra: orderId);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.secondary,
                  ),
                  child: state.loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(),
                        )
                      : const Text("Save Changes"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
