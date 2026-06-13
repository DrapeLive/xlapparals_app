import 'dart:typed_data';

import 'package:xlapparals_app/features/agent/orders/orderform/data/data_source/order_form_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/models/order_invoice_model.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/repositories/order_form_repository.dart';

class OrderInvoiceRepositoryImpl implements OrderInvoiceRepository {
  final OrderFormDataSource source;

  OrderInvoiceRepositoryImpl(this.source);

  @override
  Future<OrderInvoiceModel> getInvoice(int orderId) async {
    return await source.get(orderId);
  }

  @override
  Future<void> downloadPdf(int orderId) async {
    await source.downloadPdf(orderId);
  }

  @override
  Future<Uint8List> getPdfBytes(int orderId) async {
    return await source.getPdfBytes(orderId);
  }
}
