import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/models/order_invoice_model.dart';

import 'dart:typed_data';

abstract class OrderFormDataSource {
  Future<OrderInvoiceModel> get(int orderId);

  Future<void> downloadPdf(int orderId);

  Future<Uint8List> getPdfBytes(int orderId);
}

class OrderFormDataSourceImpl extends OrderFormDataSource {
  final Dio dio;

  OrderFormDataSourceImpl(this.dio);

  @override
  Future<OrderInvoiceModel> get(int orderId) async {
    final response = await dio.get("/orders/$orderId/invoice/");

    return OrderInvoiceModel.fromJson(response.data);
  }

  @override
  Future<void> downloadPdf(int orderId) async {
    final dir = await getApplicationDocumentsDirectory();

    final path = "${dir.path}/invoice_$orderId.pdf";

    await dio.download("/orders/$orderId/pdf/", path);

    await OpenFilex.open(path);
  }

  @override
  Future<Uint8List> getPdfBytes(int orderId) async {
    final response = await dio.get(
      "/orders/$orderId/pdf/",
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
  }
}
