import 'package:xlapparals_app/features/agent/home/domain/entities/item.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems(int id);
}
