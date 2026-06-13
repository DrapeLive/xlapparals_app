import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/customer_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/agent_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/blocs/scan_bloc.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<OrdersBloc>(create: (_) => sl<OrdersBloc>()),
        BlocProvider(create: (_) => BottomNavBloc()),
        BlocProvider<ItemFetchBloc>(create: (_) => sl<ItemFetchBloc>()),
        BlocProvider(create: (_) => ItemBloc()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<CustomerBloc>()..add(FetchCustomers())),
        BlocProvider(create: (_) => sl<OrderDetailsBloc>()),
        BlocProvider(create: (_) => sl<CreateOrderBloc>()),
        BlocProvider(create: (_) => sl<ScanBloc>()),
        BlocProvider(create: (_) => sl<ItemDetailsBloc>()),
        BlocProvider(create: (_) => sl<AgentBloc>()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        theme: AppTheme.lightTheme,

        routerConfig: AppRouter.router,
      ),
    );
  }
}
