import 'package:xlapparals_app/features/agent/home/data/datasources/items_remote_source.dart';
import 'package:xlapparals_app/features/agent/home/data/models/item_model.dart';
import 'package:xlapparals_app/features/agent/home/domain/repositories/item_repository.dart';

class ItemsRepositoryImpl implements ItemRepository {
  final ItemsRemoteDatasource datasource;

  ItemsRepositoryImpl(this.datasource);

  @override
  Future<List<ItemModel>> getItems(int id) async {
    final response = await datasource.getItems(id);

    return response;
  }
}
