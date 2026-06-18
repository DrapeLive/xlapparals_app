import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_detail_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_event.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 7),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Qunatity",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ItemDetailsBloc>().add(DecrementQuantity());
                },
                icon: const Icon(Icons.remove, color: AppColors.textPrimary),
              ),
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(
                    state.quantity.toString(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<ItemDetailsBloc>().add(IncrementQuantity());
                },
                icon: const Icon(Icons.add, color: AppColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}
