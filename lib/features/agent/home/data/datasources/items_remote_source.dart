import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/home/data/models/item_model.dart';
import 'package:xlapparals_app/shared/services/local_cache_service.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

abstract class ItemsRemoteDatasource {
  Future<List<ItemModel>> getItems(int id);

  Future<List<ItemModel>?> getCachedItems(int id);
}

class ItemsRemoteDatasourceImpl implements ItemsRemoteDatasource {
  static String _cacheKey(int id) => 'items_$id';

  final Dio dio;
  UserStorageService storage;
  final LocalCacheService localCache;
  ItemsRemoteDatasourceImpl(this.dio, this.storage, this.localCache);

  @override
  Future<List<ItemModel>> getItems(int id) async {
    final response = await dio.get("/agents/profile/$id");

    final res = response.data["assigned_items"];

<<<<<<< HEAD
=======
    // Persist the raw list for stale-while-revalidate on next launch.
    await localCache.write(_cacheKey(id), res);
>>>>>>> ae51382 (Update agent app features)

    await storage.saveAgent(
      id: response.data["id"],
      role: response.data["user"]["role"],
      contact: response.data["contact"],
      email: response.data["user"]["email"],
      totalCustomers: response.data["total_customers"],
      userId: response.data["user"]["id"],
      username: response.data["user"]["username"],
    );

    return (res as List).map((item) => ItemModel.fromJson(item)).toList();
  }

  @override
  Future<List<ItemModel>?> getCachedItems(int id) async {
    final raw = await localCache.read(_cacheKey(id));
    if (raw == null) return null;
    return ItemModel.listFromJson(raw as List);
  }
}
