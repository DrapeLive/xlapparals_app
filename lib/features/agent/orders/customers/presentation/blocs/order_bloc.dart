import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/customers/domain/repository/order_repository.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_event.dart';
import 'package:xlapparals_app/features/agent/orders/customers/presentation/blocs/order_state.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final CreateOrderRepository repository;
  final UserStorageService userStorageService;

  CreateOrderBloc({required this.repository, required this.userStorageService})
    : super(const CreateOrderState()) {
    on<CreateDraftOrder>(_createOrder);
  }

  Future<void> _createOrder(
    CreateDraftOrder event,
    Emitter<CreateOrderState> emit,
  ) async {
    try {
      emit(state.copyWith(status: CreateOrderStatus.loading));

      final agent = await userStorageService.getAgent();

      if (agent == null) {
        throw Exception("Agent not found");
      }

      final order = await repository.createOrder(
        customerId: event.customerId,
        agentId: agent.id,
      );

      emit(state.copyWith(status: CreateOrderStatus.success, order: order));
    } catch (e) {
      emit(
        state.copyWith(status: CreateOrderStatus.failure, error: e.toString()),
      );
    }
  }
}
