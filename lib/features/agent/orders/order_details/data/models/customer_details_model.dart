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
      id: json["id"] ?? 0,
      name: json["name"]?.toString() ?? "",
      contact: json["contact"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
      gst: json["gst"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "contact": contact,
      "address": address,
      "gst": gst,
    };
  }
}
