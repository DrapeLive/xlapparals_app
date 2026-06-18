import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_state.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_state.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_state.dart';
import 'package:xlapparals_app/features/agent/home/presentation/pages/history_page.dart';
import 'package:xlapparals_app/features/agent/home/presentation/pages/items_page.dart';
import 'package:xlapparals_app/features/agent/home/presentation/pages/orders_page.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/nav.dart';
import 'package:xlapparals_app/shared/pages/error_page.dart';
import 'package:xlapparals_app/shared/pages/loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<OrdersBloc>().add(FetchOrders());
    context.read<ItemFetchBloc>().add(FetchItems());
  }

  Future<void> _refreshOrders() async {
    context.read<OrdersBloc>().add(FetchOrders());
    context.read<ItemFetchBloc>().add(FetchItems());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Custom action
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text('Exit?'),
            content: const Text('Do you want to go back?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: SafeArea(
        top: false,
        child: BlocBuilder<BottomNavBloc, BottomNavState>(
          builder: (context, navState) {
            return BlocBuilder<ItemFetchBloc, ItemFetchState>(
              builder: (context, itemState) {
                return BlocBuilder<OrdersBloc, OrdersState>(
                  builder: (context, orderState) {
                    if (orderState is OrdersLoading ||
                        itemState is ItemFetchLoading) {
                      return const LoadingPage(
                        message: "Fetching latest data...",
                      );
                    }
                    if (orderState is OrdersError) {
                      return ErrorPage(
                        message: orderState.message,
                        onRetry: () {
                          context.read<OrdersBloc>().add(FetchOrders());
                        },
                      );
                    }
                    if (itemState is ItemFetchError) {
                      return ErrorPage(
                        message: itemState.message,
                        onRetry: () {
                          context.read<ItemFetchBloc>().add(FetchItems());
                        },
                      );
                    }

                    if (orderState is OrdersLoaded &&
                        itemState is ItemFetchLoaded) {
                      final pendingOrders = orderState.orders.where((order) {
                        return order.status == "PENDING" ||
                            order.status == "PACKED";
                      }).toList();

                      final dispatchedOrders = orderState.orders.where((order) {
                        return order.status == "DISPATCHED";
                      }).toList();

                      final pages = [
                        RefreshIndicator(
                          onRefresh: _refreshOrders,
                          child: HistoryPage(orders: dispatchedOrders),
                        ),
                        RefreshIndicator(
                          onRefresh: _refreshOrders,
                          child: OrdersPage(orders: pendingOrders),
                        ),
                        RefreshIndicator(
                          onRefresh: _refreshOrders,
                          child: ItemsPage(items: itemState.items),
                        ),
                      ];

                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: AppColors.secondary,
                          actionsPadding: const EdgeInsets.only(right: 15),
                          actions: [
                            GestureDetector(
                              onTap: () {
                                context.go(RouteNames.agentProfile);
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadius,
                                  ),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 34,
                                ),
                              ),
                            ),
                          ],
                        ),

                        body: IndexedStack(
                          index: navState.selectedIndex,
                          children: pages,
                        ),

                        bottomNavigationBar: Container(
                          padding: const EdgeInsets.only(
                            //bottom: 15,
                            left: 15,
                            right: 15,
                          ),
                          height: 55,
                          width: double.infinity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius,
                              ),
                              color: AppColors.secondary,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 10),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                navBar(
                                  isOrder: navState.selectedIndex == 1,
                                  isSelect: navState.selectedIndex == 0,
                                  icon: Icons.history,
                                  text: "History",
                                  onTap: () {
                                    context.read<BottomNavBloc>().add(
                                      ChangeTabEvent(0),
                                    );
                                  },
                                ),
                                navBar(
                                  isOrder: navState.selectedIndex == 1,
                                  isSelect: navState.selectedIndex == 1,
                                  icon: Icons.receipt_long,
                                  text: "Orders",
                                  onPress: () {
                                    context.go(RouteNames.agentOrderCustomers);
                                  },
                                  onTap: () {
                                    context.read<BottomNavBloc>().add(
                                      ChangeTabEvent(1),
                                    );
                                  },
                                ),
                                navBar(
                                  isOrder: navState.selectedIndex == 1,
                                  isSelect: navState.selectedIndex == 2,
                                  icon: Icons.inventory_2,
                                  text: "Items",
                                  onTap: () {
                                    context.read<BottomNavBloc>().add(
                                      ChangeTabEvent(2),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return const Scaffold(body: SizedBox());
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
