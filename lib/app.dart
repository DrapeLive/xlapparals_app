import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/expand_item/item_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/items/fetch_item/item_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/orders/orders_bloc.dart';

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
