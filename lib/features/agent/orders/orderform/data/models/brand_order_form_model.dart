import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/brand_order_form.dart';

class BrandOrderFormModel extends BrandOrderForm {
  const BrandOrderFormModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.email,
    required super.addressLine1,
    required super.addressLine2,
    required super.gst,
    required super.logoUrl,
  });

  factory BrandOrderFormModel.fromJson(Map<String, dynamic> json) {
    return BrandOrderFormModel(
      id: json["id"],
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      addressLine1: json["address_line1"] ?? "",
      addressLine2: json["address_line2"],
      gst: json["gst"] ?? "",
      logoUrl: json["logo_url"] ?? "",
    );
  }
}
