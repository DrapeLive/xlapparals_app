abstract class ScanEvent {}

class ScanDetected extends ScanEvent {
  final String qrCode;
  final int orderId;
  final int agentId;

  ScanDetected({required this.qrCode, required this.orderId, required this.agentId});
}

class ResetScanner extends ScanEvent {}
