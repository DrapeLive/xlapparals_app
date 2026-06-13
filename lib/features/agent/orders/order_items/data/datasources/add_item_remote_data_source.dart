import 'package:dio/dio.dart';

import '../models/item_details_model.dart';

abstract class AddItemRemoteDataSource {
  Future<ItemDetailsModel> getItemByQr({
    required String qrCode,
    required int agentId,
  });

  Future<void> addItemToOrder({
    required int orderId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  });
}

class AddItemRemoteDataSourceImpl implements AddItemRemoteDataSource {
  final Dio dio;

  AddItemRemoteDataSourceImpl(this.dio);

  @override
  Future<ItemDetailsModel> getItemByQr({
    required String qrCode,
    required int agentId,
  }) async {
    final response = await dio.get(
      '/items/by-qr/',
      queryParameters: {'qr_code': qrCode, 'agent_id': agentId},
    );

    return ItemDetailsModel.fromJson(response.data);
  }

  @override
  Future<void> addItemToOrder({
    required int orderId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  }) async {
    await dio.post(
      '/orders/$orderId/add-item/',
      data: {'qr_code': qrCode, 'quantity': quantity, 'size_group': sizeGroup},
    );
  }
}
