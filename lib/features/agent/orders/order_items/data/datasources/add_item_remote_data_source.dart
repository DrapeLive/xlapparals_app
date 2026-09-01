import 'package:dio/dio.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/models/order_details_model.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/data/models/order_item_model.dart';

import '../models/item_details_model.dart';

abstract class AddItemRemoteDataSource {
  Future<ItemDetailsModel> getItemByQr({
    required String qrCode,
    required int agentId,
  });

  Future<void> addItemToOrder({
    required int orderId,
    required int variantId,
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
    required int variantId,
    required String qrCode,
    required int quantity,
    required String sizeGroup,
  }) async {
    // 1. Fetch current order details to check for duplicates
    final orderResponse = await dio.get('/orders/$orderId/');
    final orderDetails = OrderDetailsModel.fromJson(orderResponse.data);

    // 2. Find if this variant and sizeGroup already exist
    OrderItemModel? existingItem;
    for (var item in orderDetails.items) {
      if (item is OrderItemModel &&
          item.variant == variantId &&
          item.sizeGroup == sizeGroup) {
        existingItem = item;
        break;
      }
    }

    if (existingItem != null) {
      // 3. Update quantity if duplicate exists
      await dio.patch(
        '/orders/order-items/${existingItem.id}/',
        data: {'quantity': quantity},
      );
    } else {
      // 4. Otherwise add as new item
      await dio.post(
        '/orders/$orderId/add-item/',
        data: {
          'qr_code': qrCode,
          'quantity': quantity,
          'size_group': sizeGroup,
        },
      );
    }

    // 5. Update order details defaults
    await dio.patch(
      '/orders/$orderId/',
      data: {
        'expected_delivery_date': null,
        'preferred_transport': null,
        'notes': null,
      },
    );
  }
}
