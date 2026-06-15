import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/item_card.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/summary_card.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';

class OrderInformView extends StatelessWidget {
  const OrderInformView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: BackButton(
          onPressed: () {
            context.go(RouteNames.agentHome);
          },
        ),
        title: const Text(""),
        actions: [
          BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
            builder: (context, state) {
              final order = state.order;

              if (order == null) {
                return const SizedBox.shrink();
              }

              return GestureDetector(
                onTap: () {
                  context.go(RouteNames.po, extra: order.id);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text("PO", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          if (state.status == OrderDetailsStatus.loading) {
            return const LoadingPage(message: "Fetching Order..");
          }

          if (state.status == OrderDetailsStatus.failure) {
            return Center(child: Text("Failed to Fetch"));
          } else {
            final order = state.order;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order != null) OrderSummaryCard(order: order),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Packing Status",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (order != null)
                    ...order.items.map(
                      (item) => OrderInformItemCard(item, order.status),
                    ),
                  const SizedBox(height: 24),

                  if (order?.status == "PENDING")
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              if (order != null) {
                                context.read<OrderDetailsBloc>().add(
                                  StartEditOrder(order.id),
                                );
                                context.go(
                                  RouteNames.editOrder,
                                  extra: order.id,
                                );
                              }
                            },

                            icon: const Icon(Icons.edit_outlined),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                            ),
                            label: const Text("Edit"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              if (order != null) {
                                context.read<OrderDetailsBloc>().add(
                                  DeleteOrder(order.id),
                                );
                                context.go(RouteNames.agentHome);
                              }
                            },

                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                              side: BorderSide(
                                color: AppColors.red,
                                width: 1.5,
                              ),
                            ),

                            icon: const Icon(Icons.delete_outline),

                            label: const Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
