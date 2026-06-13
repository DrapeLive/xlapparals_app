import 'package:xlapparals_app/features/agent/orders/scanner/data/datasource/scan_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDatasource datasource;

  ScanRepositoryImpl(this.datasource);

  @override
  Future<ScanResponse> checkQr({required String qrCode, required int orderId}) {
    return datasource.checkQr(qrCode: qrCode, orderId: orderId);
  }
}
