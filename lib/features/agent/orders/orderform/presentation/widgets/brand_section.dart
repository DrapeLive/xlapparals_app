import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class BrandSection extends StatelessWidget {
  final OrderInvoice invoice;

  const BrandSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final brand = invoice.brand;

    if (brand == null) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (brand.logoUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: brand.logoUrl,
            height: 80,
            fit: BoxFit.contain,
            placeholder: (_, _) => const SizedBox(
              height: 80,
              child: Center(
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (_, _, _) => const SizedBox.shrink(),
          ),

        const SizedBox(height: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              brand.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              brand.addressLine1,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),

            if (brand.addressLine2 != null && brand.addressLine2!.isNotEmpty)
              Text(
                brand.addressLine2!,
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.primary, fontSize: 12),
              ),

            const SizedBox(height: 4),

            Text(
              brand.phone,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),

            Text(
              brand.email,
              textAlign: TextAlign.right,
              style: TextStyle(color: AppColors.primary, fontSize: 12),
            ),

            const SizedBox(height: 4),

            if (brand.gst.isNotEmpty)
              Text(
                "GST : ${brand.gst}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
