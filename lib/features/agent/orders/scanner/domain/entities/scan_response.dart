class ScanResponse {
  final bool outOfStock;
  final Map<String, dynamic> groupStock;

  const ScanResponse({required this.outOfStock, required this.groupStock});
}
