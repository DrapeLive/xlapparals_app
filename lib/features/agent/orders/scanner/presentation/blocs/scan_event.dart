abstract class ScanEvent {}

class ScanDetected extends ScanEvent {
  final String qrCode;
  final int orderId;

  ScanDetected({required this.qrCode, required this.orderId});
}

class ResetScanner extends ScanEvent {}
