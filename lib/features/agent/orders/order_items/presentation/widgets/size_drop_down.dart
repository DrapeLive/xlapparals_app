import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/core/utils/size_utils.dart';
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

    if (state.item?.type == 'kids') {
      return SizeRangeUtils.getDefaultKidsSize(sizes)?.sizeRange;
    }

    return sizes.isNotEmpty ? sizes.first.sizeRange : null;
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
          isExpanded: true,
          selectedItemBuilder: (context) {
            return sizes.map((size) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(size.sizeRange, style: TextStyle(fontSize: 12, color: AppColors.primary)),
                  Text('${size.stock} in stock', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                ],
              );
            }).toList();
          },
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
