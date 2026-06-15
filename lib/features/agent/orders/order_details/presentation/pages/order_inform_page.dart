import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/widgets/order_inform_view.dart';
import 'package:xlapparals_app/injection_container.dart';

class OrderInformPage extends StatelessWidget {
  final int orderId;

  const OrderInformPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderDetailsBloc>()..add(FetchOrderDetails(orderId)),
      child: const OrderInformView(),
    );
  }
}
