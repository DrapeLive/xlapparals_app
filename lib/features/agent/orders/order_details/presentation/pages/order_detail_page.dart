import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/customer_info_card.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/delivery_option_card.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/order_item_section.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/order_summary_card.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<AgentBloc>().add(LoadAgent());

    context.read<OrderDetailsBloc>().add(FetchOrderDetails(widget.orderId));

    context.read<OrderDetailsBloc>().add(LoadTransports());
  }

  Future<void> _refresh() async {
    context.read<OrderDetailsBloc>().add(RefreshOrderDetails(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(RouteNames.agentOrderCustomers);
          },
        ),
      ),
      body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
        builder: (context, state) {
          if (state.status == OrderDetailsStatus.loading) {
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
                CustomerInfoCard(customer: order.customerDetails),

                const SizedBox(height: 10),

                DeliveryOptionsCard(),

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

                    BlocBuilder<AgentBloc, AgentState>(
                      builder: (context, agentState) {
                        final agentId = agentState.agent?.userId;

                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius,
                              ),
                            ),
                          ),
                          onPressed: agentId == null
                              ? null
                              : () {
                                  context.go(
                                    RouteNames.scanner,
                                    extra: {
                                      'orderId': state.order?.id,
                                      'agentId': agentId,
                                    },
                                  );
                                },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                OrderItemsSection(items: order.items),

                const SizedBox(height: 16),

                if (order.items.isNotEmpty)
                  OrderSummaryCard(order: order, orderId: widget.orderId),
              ],
            ),
          );
        },
      ),
    );
  }
}
