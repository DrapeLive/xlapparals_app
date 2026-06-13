import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/home/data/models/item_model.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

abstract class ItemsRemoteDatasource {
  Future<List<ItemModel>> getItems(int id);
}

class ItemsRemoteDatasourceImpl implements ItemsRemoteDatasource {
  final Dio dio;
  UserStorageService storage;
  ItemsRemoteDatasourceImpl(this.dio, this.storage);

  @override
  Future<List<ItemModel>> getItems(int id) async {
    final response = await dio.get("/agents/profile/$id");

    final res = response.data["assigned_items"];

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
}
