import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/repositories/scan_repository.dart';

class CheckQrUsecase {
  final ScanRepository repository;

  CheckQrUsecase(this.repository);

  Future<ScanResponse> call({required String qrCode, required int orderId}) {
    return repository.checkQr(qrCode: qrCode, orderId: orderId);
  }
}
