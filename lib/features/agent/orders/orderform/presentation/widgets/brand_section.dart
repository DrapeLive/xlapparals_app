import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class BrandSection extends StatelessWidget {
  final OrderInvoice invoice;

  const BrandSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final brand = invoice.brand;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (brand.logoUrl.isNotEmpty)
          Image.network(brand.logoUrl, height: 80, fit: BoxFit.contain),

        const SizedBox(height: 12),

        Column(
          children: [
            Text(
              brand.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              brand.addressLine1,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary),
            ),

            if (brand.addressLine2 != null && brand.addressLine2!.isNotEmpty)
              Text(
                brand.addressLine2!,
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.primary),
              ),

            const SizedBox(height: 4),

            Text(
              brand.phone,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary),
            ),

            Text(
              brand.email,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary),
            ),

            const SizedBox(height: 4),

            Text(
              "GST : ${brand.gst}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
