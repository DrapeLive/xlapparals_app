import 'package:flutter/material.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

class BrandSection extends StatelessWidget {
  final OrderInvoice invoice;

  const BrandSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final brand = invoice.brand;

    return Column(
      children: [
        if (brand.logoUrl.isNotEmpty)
          Image.network(brand.logoUrl, height: 80, fit: BoxFit.contain),

        const SizedBox(height: 12),

        Text(
          brand.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(brand.addressLine1, textAlign: TextAlign.center),

        if (brand.addressLine2 != null && brand.addressLine2!.isNotEmpty)
          Text(brand.addressLine2!, textAlign: TextAlign.center),

        const SizedBox(height: 4),

        Text(brand.phone, textAlign: TextAlign.center),

        Text(brand.email, textAlign: TextAlign.center),

        const SizedBox(height: 4),

        Text(
          "GST : ${brand.gst}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
