import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/bloc/order_form_event.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/presentation/widgets/order_form_view.dart';
import 'package:xlapparals_app/injection_container.dart';

class OrderInvoicePage extends StatelessWidget {
  final int orderId;

  const OrderInvoicePage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderInvoiceBloc>()..add(LoadOrderInvoice(orderId)),
      child: OrderInvoiceView(),
    );
  }
}
