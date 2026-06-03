import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/home/data/models/item_model.dart';

abstract class ItemsRemoteDatasource {
  Future<List<ItemModel>> getItems(int id);
}

class ItemsRemoteDatasourceImpl implements ItemsRemoteDatasource {
  final Dio dio;

  ItemsRemoteDatasourceImpl(this.dio);

  @override
  Future<List<ItemModel>> getItems(int id) async {
    final response = await dio.get("/agents/profile/$id");

    final res = response.data["assigned_items"];

    return (res as List).map((item) => ItemModel.fromJson(item)).toList();
  }
}
