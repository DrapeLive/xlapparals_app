import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  ({Color textColor, Color bgColor}) _getColors() {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return (
          textColor: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
        );

      case 'PACKED':
        return (
          textColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFDBEAFE),
        );

      case 'DISPATCHED':
        return (
          textColor: const Color(0xFF16A34A),
          bgColor: const Color(0xFFDCFCE7),
        );

      default:
        return (textColor: Colors.grey.shade700, bgColor: Colors.grey.shade100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: colors.textColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          color: colors.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
