import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanReady extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final ScanResponse data;
  final String qrCode;

  ScanSuccess({required this.data, required this.qrCode});
}

class ScanError extends ScanState {
  final String message;

  ScanError(this.message);
}
