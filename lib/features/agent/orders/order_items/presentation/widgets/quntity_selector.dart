import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_detail_state.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/order_items/presentation/blocs/item_details_event.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  Future<void> _showQuantityInputDialog(
    BuildContext context,
    int currentQty,
  ) async {
    final controller = TextEditingController(text: currentQty.toString());
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Text(
            'Enter Quantity',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: AppColors.textPrimary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onSubmitted: (value) {
              final parsed = int.tryParse(value);
              Navigator.of(dialogContext).pop(parsed != null && parsed >= 1 ? parsed : null);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text);
                Navigator.of(dialogContext).pop(
                  parsed != null && parsed >= 1 ? parsed : null,
                );
              },
              child: Text(
                'Set',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<ItemDetailsBloc>().add(SetQuantity(result));
    }
  }

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
                "Quantity",
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
              Tooltip(
                message: 'Tap to type quantity',
                child: GestureDetector(
                  onTap: () =>
                      _showQuantityInputDialog(context, state.quantity),
                  child: Container(
                    width: 58,
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
