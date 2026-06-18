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

  String? _getDefaultValue(ItemDetailsState state, List<ItemSize> sizes) {
    if (state.selectedSize != null) {
      return state.selectedSize!.sizeRange;
    }

    final size2036 = sizes.where((e) => e.sizeRange == '20-36' && e.stock > 0);

    if (size2036.isNotEmpty) {
      return '20-36';
    }

    final size2030 = sizes.where((e) => e.sizeRange == '20-30' && e.stock > 0);

    if (size2030.isNotEmpty) {
      return '20-30';
    }

    if (sizes.isNotEmpty) {
      return sizes.first.sizeRange;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
      builder: (context, state) {
        final selectedValue = _getDefaultValue(state, sizes);

        return DropdownButtonFormField<String>(
          initialValue: selectedValue,
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
          ),
          iconEnabledColor: AppColors.primary,
          items: sizes.map((size) {
            return DropdownMenuItem<String>(
              value: size.sizeRange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(size.sizeRange, style: TextStyle(fontSize: 12)),
                  Text('${size.stock}', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value == null) return;

            final selectedSize = sizes.firstWhere(
              (size) => size.sizeRange == value,
            );

            context.read<ItemDetailsBloc>().add(ChangeSize(selectedSize));
          },
        );
      },
    );
  }
}
