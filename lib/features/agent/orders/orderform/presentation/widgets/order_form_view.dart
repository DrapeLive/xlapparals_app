import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_event.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_states.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/agent_section.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/brand_section.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/customer_section.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/items_table.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/total_section.dart';

class OrderInvoiceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RouteNames.agentHome);
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go(RouteNames.agentHome);
              },
            ),
          ),
          body: BlocBuilder<OrderInvoiceBloc, OrderInvoiceState>(
            builder: (context, state) {
              if (state is OrderInvoiceLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is OrderInvoiceError) {
                return Center(child: Text(state.message));
              }

              if (state is OrderInvoiceLoaded) {
                final invoice = state.invoice;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BrandSection(invoice: invoice),

                      const SizedBox(height: 12),
                      Divider(height: 5, color: AppColors.primary),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ORDER FORM",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Column(
                            children: [
                              Text(
                                "Order Form #${invoice.id}",
                                style: TextStyle(color: AppColors.primary),
                              ),

                              Text(
                                "Date : ${DateFormat('dd/MM/yyyy').format(invoice.createdAt)}",
                                style: TextStyle(color: AppColors.primary),
                              ),

                              Text(
                                "Time : ${DateFormat('hh:mm:ss a').format(invoice.createdAt)}",
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      CustomerSection(invoice: invoice),

                      const SizedBox(height: 20),

                      AgentSection(invoice: invoice),

                      const SizedBox(height: 24),

                      ItemsTable(invoice),

                      const SizedBox(height: 20),

                      TotalsSection(invoice),

                      const SizedBox(height: 40),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<OrderInvoiceBloc>().add(
                                  DownloadInvoice(invoice.id),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Download"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.secondary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<OrderInvoiceBloc>().add(
                                  ShareInvoice(invoice.id),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text("Share"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
