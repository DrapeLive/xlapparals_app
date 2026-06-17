import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';

class AvatarLetterWidget extends StatelessWidget {
  final String text;

  const AvatarLetterWidget({super.key, required this.text});

  static const List<Color> _colors = [
    Color(0xFFE53935), // Red
    Color(0xFF8E24AA), // Purple
    Color(0xFF3949AB), // Indigo
    Color(0xFF1E88E5), // Blue
    Color(0xFF00897B), // Teal
    Color(0xFF43A047), // Green
    Color(0xFFF4511E), // Orange
    Color(0xFF6D4C41), // Brown
    Color(0xFF546E7A), // Blue Grey
    Color(0xFFD81B60), // Pink
  ];

  Color _getColor(String value) {
    final index = value.toUpperCase().codeUnitAt(0) % _colors.length;

    return _colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final letter = text.trim().isEmpty ? '?' : text[0].toUpperCase();

    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _getColor(letter),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
