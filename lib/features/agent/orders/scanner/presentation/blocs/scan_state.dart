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

/// Emitted when the backend returns HTTP 400 — the scanned item is not
/// assigned to any order / agent.
class ScanUnassigned extends ScanState {}
