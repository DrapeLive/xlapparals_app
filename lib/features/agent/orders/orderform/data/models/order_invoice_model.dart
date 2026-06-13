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
    return OrderInvoiceModel(
      id: json["id"],
      customer: CustomerOrderFormModel.fromJson(json["customer"]),
      agent: AgentOrderFormModel.fromJson(json["agent"]),
      brand: BrandOrderFormModel.fromJson(json["brand"]),
      createdAt: DateTime.parse(json["created_at"]),
      status: json["status"],
      items: (json["items"] as List)
          .map((e) => OrderItemOrderFormModel.fromJson(e))
          .toList(),
      totalPrice: double.parse(json["total_price"].toString()),
      gstRate: double.parse(json["gst_rate"].toString()),
    );
  }
}
