import 'package:dio/dio.dart';
import 'package:xlapparals_app/shared/services/local_cache_service.dart';

import '../models/order_model.dart';
import '../models/orders_response_model.dart';

abstract class OrdersRemoteDatasource {
  Future<OrdersResponseModel> getOrders();

  Future<List<OrderModel>?> getCachedOrders();
}

class OrdersRemoteDatasourceImpl implements OrdersRemoteDatasource {
  static const String _cacheKey = 'orders';

  final Dio dio;
  final LocalCacheService localCache;

  OrdersRemoteDatasourceImpl(this.dio, this.localCache);

  @override
  Future<OrdersResponseModel> getOrders() async {
    final response = await dio.get("/orders/");

    // Persist the raw list for stale-while-revalidate on next launch.
    await localCache.write(_cacheKey, response.data['results']);

    return OrdersResponseModel.fromJson(response.data);
  }

  @override
  Future<List<OrderModel>?> getCachedOrders() async {
    final raw = await localCache.read(_cacheKey);
    if (raw == null) return null;
    return OrderModel.listFromJson(raw as List);
  }
}
