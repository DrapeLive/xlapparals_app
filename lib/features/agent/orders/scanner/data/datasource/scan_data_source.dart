import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/data/models/scan_response_model.dart';

abstract class ScanRemoteDatasource {
  Future<ScanResponseModel> checkQr({
    required String qrCode,
    required int orderId,
  });
}

class ScanRemoteDatasourceImpl implements ScanRemoteDatasource {
  final Dio dio;

  ScanRemoteDatasourceImpl(this.dio);

  @override
  Future<ScanResponseModel> checkQr({
    required String qrCode,
    required int orderId,
  }) async {
    final response = await dio.get(
      '/items/by-qr/out-of-stock/',
      queryParameters: {'qr_code': qrCode, 'order_id': orderId},
    );

    return ScanResponseModel.fromJson(response.data);
  }
}
