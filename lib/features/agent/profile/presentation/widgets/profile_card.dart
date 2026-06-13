import 'package:flutter/material.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final Agent profile;

  const ProfileCard({super.key, required this.profile});

  Widget _row(IconData icon, Color color, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(.1),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _row(Icons.person_outline, Colors.blue, "USERNAME", profile.username),
          _row(Icons.mail_outline, Colors.purple, "EMAIL", profile.email),
          _row(Icons.phone_outlined, Colors.orange, "CONTACT", profile.contact),
        ],
      ),
    );
  }
}
