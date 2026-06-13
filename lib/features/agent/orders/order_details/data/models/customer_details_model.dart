import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/customer_detals.dart';

class CustomerDetailsModel extends CustomerDetails {
  CustomerDetailsModel({
    required super.id,
    required super.name,
    required super.contact,
    required super.address,
    required super.gst,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      id: json["id"],
      name: json["name"] ?? "",
      contact: json["contact"] ?? "",
      address: json["address"] ?? "",
      gst: json["gst"] ?? "",
    );
  }
}
