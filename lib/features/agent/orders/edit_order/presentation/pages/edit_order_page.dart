import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_event.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/bloc/edit_order_state.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/widgets/edit_delivery_option_card.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/widgets/edit_order_item_section.dart';
import 'package:xlapparals_app/features/agent/orders/edit_order/presentation/widgets/edit_order_summary.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';

class EditOrderPage extends StatefulWidget {
  final int orderId;

  const EditOrderPage({super.key, required this.orderId});

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  @override
  void initState() {
    super.initState();

    context.read<EditOrderBloc>().add(FetchEditOrderDetails(widget.orderId));

    context.read<EditOrderBloc>().add(LoadTransports());
  }

  Future<void> _refresh() async {
    context.read<EditOrderBloc>().add(RefreshOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(RouteNames.orderInform, extra: widget.orderId);
          },
        ),
      ),
      body: BlocBuilder<EditOrderBloc, EditOrderState>(
        builder: (context, state) {
          if (state.loading) {
            return const LoadingPage(message: "Fetching Order..");
          }

          if (state.order == null) {
            return const SizedBox();
          }

          final order = state.order!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),

                EditDeliveryOptionsCard(order),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Order Items",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadius,
                          ),
                        ),
                      ),
                      onPressed: state.order?.agentDetails.id == null
                          ? null
                          : () {
                              context.go(
                                RouteNames.scanner,
                                extra: {
                                  'orderId': state.order?.id,
                                  'agentId': state.order?.agentDetails.id,
                                },
                              );
                            },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Item"),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                EditOrderItemsSection(items: order.items, orderId: order.id),

                const SizedBox(height: 16),

                if (order.items.isNotEmpty)
                  EditOrderSummaryCard(order: order, orderId: widget.orderId),
              ],
            ),
          );
        },
      ),
    );
  }
}
