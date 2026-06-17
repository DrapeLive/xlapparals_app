import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

Widget navBar({
  required bool isOrder,
  required bool isSelect,
  required String text,
  required IconData icon,
  required void Function() onTap,
  void Function()? onPress,
}) {
  return GestureDetector(
    onTap: isOrder & isSelect ? onPress : onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isOrder & isSelect ? AppColors.orange : AppColors.secondary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isOrder & isSelect ? Icons.add : icon,
              color: isOrder & isSelect
                  ? AppColors.secondary
                  : isSelect
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
            Text(
              isOrder & isSelect ? "New Orders" : text,
              style: TextStyle(
                color: isOrder & isSelect
                    ? AppColors.secondary
                    : isSelect
                    ? AppColors.primary
                    : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: isSelect ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
