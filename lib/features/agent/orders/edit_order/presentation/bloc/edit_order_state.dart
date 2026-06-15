import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';

class EditOrderState {
  final bool loading;
  final bool saving;

  final DateTime? expectedDate;
  final Transport? transport;

  final String? error;

  final List<Transport> transports;
  final bool loadingTransports;

  final OrderDetails? order;

  const EditOrderState({
    this.loading = false,
    this.saving = false,
    this.expectedDate,
    this.transports = const [],
    this.loadingTransports = false,
    this.order,
    this.transport,
    this.error,
  });

  EditOrderState copyWith({
    bool? loading,
    bool? saving,
    DateTime? expectedDate,
    Transport? transport,
    String? error,
    List<Transport>? transports,
    bool? loadingTransports,
    OrderDetails? order,
  }) {
    return EditOrderState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      expectedDate: expectedDate ?? this.expectedDate,
      transport: transport ?? this.transport,
      error: error,
      loadingTransports: loadingTransports ?? this.loadingTransports,
      transports: transports ?? this.transports,
      order: order ?? this.order,
    );
  }
}
