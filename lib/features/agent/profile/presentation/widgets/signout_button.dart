import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';

class SignOutButton extends StatelessWidget {
  SignOutButton({super.key});

  final SecureStorageService storage = SecureStorageService();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await storage.clear();
        context.go(RouteNames.login);
      },
      icon: const Icon(Icons.logout, color: Colors.red, size: 20),
      label: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}
