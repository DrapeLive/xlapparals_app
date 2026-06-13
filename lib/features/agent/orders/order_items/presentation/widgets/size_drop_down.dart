import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/domain/entities/size.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_detail_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_event.dart';

class SizeDropdown extends StatelessWidget {
  final List<ItemSize> sizes;

  const SizeDropdown({super.key, required this.sizes});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.border, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              borderSide: BorderSide(color: AppColors.border),
            ),
            fillColor: AppColors.secondary,
            iconColor: AppColors.primary,
          ),
          initialValue: state.selectedSize?.sizeRange,
          items: state.availableSizes.map((size) {
            return DropdownMenuItem<String>(
              value: size.sizeRange,
              child: Text(size.sizeRange),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final selectedSize = state.availableSizes.firstWhere(
                (size) => size.sizeRange == value,
              );

              context.read<ItemDetailsBloc>().add(ChangeSize(selectedSize));
            }
          },
        );
      },
    );
  }
}
