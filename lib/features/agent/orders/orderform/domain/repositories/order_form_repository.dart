import 'dart:typed_data';

import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

abstract class OrderInvoiceRepository {
  Future<OrderInvoice> getInvoice(int orderId);

  Future<void> downloadPdf(int orderId);

  Future<Uint8List> getPdfBytes(int orderId);
}
