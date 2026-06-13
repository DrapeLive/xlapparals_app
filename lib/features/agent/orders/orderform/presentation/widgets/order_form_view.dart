import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Order Form")),
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

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      "ORDER FORM",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text("Order Form #${invoice.id}"),

                  Text(
                    "Date : ${DateFormat('dd/MM/yyyy').format(invoice.createdAt)}",
                  ),

                  Text(
                    "Time : ${DateFormat('hh:mm:ss a').format(invoice.createdAt)}",
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
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<OrderInvoiceBloc>().add(
                              PrintInvoice(invoice.id),
                            );
                          },
                          icon: const Icon(Icons.print),
                          label: const Text("Print"),
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
    );
  }
}
