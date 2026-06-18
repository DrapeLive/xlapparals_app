import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class EmptyOrderWidget extends StatelessWidget {
  const EmptyOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 50, color: AppColors.border),
            SizedBox(height: 12),
            Text("No items added yet", style: TextStyle(fontSize: 12)),
            Text("Tap to scan or search items", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
