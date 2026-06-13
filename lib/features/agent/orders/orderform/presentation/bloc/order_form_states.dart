import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

abstract class OrderInvoiceState {}

class OrderInvoiceInitial extends OrderInvoiceState {}

class OrderInvoiceLoading extends OrderInvoiceState {}

class OrderInvoiceLoaded extends OrderInvoiceState {
  final OrderInvoice invoice;

  OrderInvoiceLoaded(this.invoice);
}

class OrderInvoiceDownloading extends OrderInvoiceState {}

class OrderInvoicePrinting extends OrderInvoiceState {}

class OrderInvoiceError extends OrderInvoiceState {
  final String message;

  OrderInvoiceError(this.message);
}
