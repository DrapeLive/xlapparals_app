import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_state.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_state.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/widgets/customer_card.dart';
import 'package:xlapparals_app/shared/pages/error_page.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';

class CreateOrderCustomerPage extends StatefulWidget {
  const CreateOrderCustomerPage({super.key});

  @override
  State<CreateOrderCustomerPage> createState() =>
      _CreateOrderCustomerPageState();
}

class _CreateOrderCustomerPageState extends State<CreateOrderCustomerPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final customerBloc = context.read<CustomerBloc>();

    if (customerBloc.state.customers.isEmpty) {
      customerBloc.add(FetchCustomers());
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerBloc>().add(LoadMoreCustomers());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _createOrder(dynamic customer) {
    final orderState = context.read<CreateOrderBloc>().state;

    if (orderState.status == CreateOrderStatus.loading) {
      return;
    }

    context.read<CreateOrderBloc>().add(
      CreateDraftOrder(customerId: customer.id, customer: customer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateOrderBloc, CreateOrderState>(
      listener: (context, orderState) {
        if (orderState.status == CreateOrderStatus.success) {
          context.push(RouteNames.orderDetails, extra: orderState.order?.id);
        }

        if (orderState.status == CreateOrderStatus.failure) {
          ErrorPage(
            message: "Failed to create order",
            onRetry: () {
              context.go(RouteNames.agentOrderCustomers);
            },
          );
        }
      },
      builder: (context, orderState) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.go(RouteNames.agentHome);
                  },
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) {
                        context.read<CustomerBloc>().add(
                          SearchCustomers(value),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Search customer...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: BlocBuilder<CustomerBloc, CustomerState>(
                      builder: (context, customerState) {
                        if (customerState.status == CustomerStatus.loading &&
                            customerState.customers.isEmpty) {
                          return const LoadingPage(
                            message: "Fetching Customers...",
                          );
                        }

                        if (customerState.customers.isEmpty) {
                          return const Center(
                            child: Text("No customers found"),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount:
                              customerState.customers.length +
                              (customerState.hasReachedMax ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index >= customerState.customers.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final customer = customerState.customers[index];

                            return CustomerCard(
                              customer: customer,
                              onTap: () => _createOrder(customer),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (orderState.status == CreateOrderStatus.loading)
              Container(
                color: Colors.black26,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
