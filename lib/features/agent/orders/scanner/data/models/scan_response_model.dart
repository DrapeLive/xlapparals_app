import 'package:xlapparals_app/features/agent/orders/scanner/domain/entities/scan_response.dart';

class ScanResponseModel extends ScanResponse {
  const ScanResponseModel({
    required super.outOfStock,
    required super.groupStock,
  });

  factory ScanResponseModel.fromJson(Map<String, dynamic> json) {
    return ScanResponseModel(
      outOfStock: json['out_of_stock'] ?? false,
      groupStock: json['group_stock'] ?? {},
    );
  }
}
