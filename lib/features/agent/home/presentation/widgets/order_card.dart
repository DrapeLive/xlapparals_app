import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
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
  final int id;

  OrderCard({
    super.key,
    required this.id,
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
    return GestureDetector(
      onTap: () {
        context.go(RouteNames.orderInform, extra: id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.border),
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
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        agentName,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 9,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        date,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 3),

            Divider(color: AppColors.border),

            const SizedBox(height: 3),
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
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                            const TextSpan(
                              text: " Sets",
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 5),

                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppColors.border,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(width: 5),

                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: "$totalPieces",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                            const TextSpan(
                              text: " pcs",
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "₹${indianCurrency.format(amount)}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
