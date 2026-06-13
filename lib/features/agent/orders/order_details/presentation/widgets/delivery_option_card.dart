import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/transport.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_event.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/presentation/blocs/order_fetch_state.dart';

class DeliveryOptionsCard extends StatelessWidget {
  const DeliveryOptionsCard({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (selected != null && context.mounted) {
      context.read<OrderDetailsBloc>().add(PickDeliveryDate(selected));
    }
  }

  Future<void> _showTransports(
    BuildContext context,
    List<Transport> transports,
  ) async {
    final selected = await showModalBottomSheet<Transport>(
      backgroundColor: AppColors.secondary,
      context: context,
      builder: (_) {
        return ListView.builder(
          padding: EdgeInsets.all(10),

          itemCount: transports.length + 1,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            if (index == 0) {
              return ListTile(
                style: ListTileStyle.list,
                splashColor: AppColors.secondary,
                title: const Text(
                  "None",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Navigator.pop(
                  context,
                  const Transport(id: 0, name: "None"),
                ),
              );
            }

            final transport = transports[index - 1];

            return ListTile(
              title: Text(
                transport.name,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(context, transport),
            );
          },
        );
      },
    );

    if (selected != null && context.mounted) {
      context.read<OrderDetailsBloc>().add(SelectTransport(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery Options",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        onTap: () => _pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.expectedDate == null
                                      ? "mm/dd/yyyy"
                                      : "${state.expectedDate!.day}/${state.expectedDate!.month}/${state.expectedDate!.year}",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadius,
                        ),
                        onTap: () => _showTransports(context, state.transports),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.selectedTransport?.name ?? "None",
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
