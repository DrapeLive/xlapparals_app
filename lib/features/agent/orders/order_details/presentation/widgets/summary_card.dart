import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/status_badge.dart';
import 'package:xlapparals_app/features/agent/orders/order_details/domain/entities/order_details.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderDetails order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CUSTOMER", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    Text(
                      order.customerDetails.name,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.customerDetails.address,
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      order.customerDetails.contact,
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      order.customerDetails.gst,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("AGENT", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 5),
                    Text(
                      order.agentDetails.username,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      order.agentDetails.contact,
                      style: TextStyle(fontSize: 10, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DATE", style: TextStyle(fontSize: 12)),
                    Text(
                      DateFormat('dd MMM yyyy').format(order.createdAt),
                      style: TextStyle(color: AppColors.primary, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CURRENT STATUS", style: TextStyle(fontSize: 12)),
                    StatusBadge(status: order.status.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Divider(color: AppColors.border),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _info(
                  "EXPECTED DELIVERY",
                  order.expectedDeliveryDate != null
                      ? DateFormat(
                          'dd MMM yyyy',
                        ).format(order.expectedDeliveryDate!)
                      : "Not Specified",
                ),
              ),
              Expanded(
                child: _info(
                  "PREFERRED TRANSPORT",
                  order.transportCompany ?? "Not specified",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
