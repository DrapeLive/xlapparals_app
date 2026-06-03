import 'order_model.dart';

class OrdersResponseModel {
  final int count;
  final List<OrderModel> orders;

  OrdersResponseModel({required this.count, required this.orders});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      count: json["count"],
      orders: (json["results"] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
    );
  }
}
