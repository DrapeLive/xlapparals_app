import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';

class CustomerTile extends StatelessWidget {
  final int count;

  const CustomerTile({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouteNames.agentOrderCustomers),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        child: Row(
          children: [
            const Icon(Icons.groups_outlined, color: Colors.teal),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "My Customers",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey.shade200,
              child: Text("$count", style: const TextStyle(fontSize: 10)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
