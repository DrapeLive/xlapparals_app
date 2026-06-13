import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/customer_order_form.dart';

class CustomerOrderFormModel extends CustomerOrderForm {
  const CustomerOrderFormModel({
    required super.id,
    required super.name,
    required super.contact,
    required super.address,
    required super.gst,
  });

  factory CustomerOrderFormModel.fromJson(Map<String, dynamic> json) {
    return CustomerOrderFormModel(
      id: json["id"],
      name: json["name"] ?? "",
      contact: json["contact"] ?? "",
      address: json["address"] ?? "",
      gst: json["gst"] ?? "",
    );
  }
}
