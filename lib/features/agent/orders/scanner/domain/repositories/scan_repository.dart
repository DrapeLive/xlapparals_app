import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';

abstract class ScanRepository {
  Future<ScanResponse> checkQr({required String qrCode, required int orderId});
}
