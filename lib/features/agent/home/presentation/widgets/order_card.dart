import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/avatar_letter_widget.dart';
import 'package:xlapparals_app/features/agent/home/presentation/widgets/status_badge.dart';

class OrderCard extends StatelessWidget {
  final String customerName;
  final String agentName;
  final String date;
  final int totalSets;
  final int totalPieces;
  final String status;
  final double amount;

  OrderCard({
    super.key,
    required this.customerName,
    required this.agentName,
    required this.date,
    required this.totalSets,
    required this.totalPieces,
    required this.status,
    required this.amount,
  });

  final indianCurrency = NumberFormat("#,##,##0", "en_IN");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarLetterWidget(text: customerName[0].toUpperCase()),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      agentName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 2),

                    Text(date, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              StatusBadge(status: status),
            ],
          ),

          const SizedBox(height: 5),

          Divider(color: AppColors.border),

          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "$totalSets",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const TextSpan(text: " Sets"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.border,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: "$totalPieces",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const TextSpan(text: " pcs"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "₹${indianCurrency.format(amount)}",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
