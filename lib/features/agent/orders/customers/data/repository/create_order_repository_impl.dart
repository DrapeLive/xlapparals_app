import 'package:xlapparals_app/features/agent/orders/customers/data/datasources/create_order_data_source.dart';
import 'package:xlapparals_app/features/agent/orders/customers/data/models/order_response_model.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/repository/order_repository.dart';

class CreateOrderRepositoryImpl implements CreateOrderRepository {
  final CreateOrderRemoteDatasource remoteDatasource;

  CreateOrderRepositoryImpl(this.remoteDatasource);

  @override
  Future<CreateOrderResponseModel> createOrder({
    required int customerId,
    required int agentId,
  }) {
    return remoteDatasource.createOrder(
      customerId: customerId,
      agentId: agentId,
    );
  }
}
