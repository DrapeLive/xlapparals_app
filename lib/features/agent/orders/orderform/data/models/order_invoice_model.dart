import 'package:xlapparals_app/features/agent/orders/orderform/data/models/agent_order_form_model.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/models/brand_order_form_model.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/models/customer_order_form_model.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/data/models/order_item_order_form_model.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class OrderInvoiceModel extends OrderInvoice {
  const OrderInvoiceModel({
    required super.id,
    required super.customer,
    required super.agent,
    required super.brand,
    required super.createdAt,
    required super.status,
    required super.items,
    required super.totalPrice,
    required super.gstRate,
  });

  factory OrderInvoiceModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedCreatedAt;
    try {
      if (json["created_at"] != null) {
        parsedCreatedAt = DateTime.parse(json["created_at"].toString());
      }
    } catch (_) {}

    return OrderInvoiceModel(
      id: json["id"] ?? 0,
      customer: json["customer"] != null
          ? CustomerOrderFormModel.fromJson(json["customer"])
          : null,
      agent: json["agent"] != null
          ? AgentOrderFormModel.fromJson(json["agent"])
          : null,
      brand: json["brand"] != null
          ? BrandOrderFormModel.fromJson(json["brand"])
          : null,
      createdAt: parsedCreatedAt,
      status: json["status"] ?? "",
      items: (json["items"] as List?)
              ?.map((e) => OrderItemOrderFormModel.fromJson(e))
              .toList() ??
          [],
      totalPrice: double.tryParse(json["total_price"]?.toString() ?? '') ?? 0,
      gstRate: double.tryParse(json["gst_rate"]?.toString() ?? '') ?? 0,
    );
  }
}
