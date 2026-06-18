import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StockBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
