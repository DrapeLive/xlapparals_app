import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/constants/app_constants.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_event.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_state.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          height: 52,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Row(
            children: [
              _tab(context, "Profile", 0, state.selectedTab),
              _tab(context, "Archives", 1, state.selectedTab),
            ],
          ),
        );
      },
    );
  }

  Widget _tab(BuildContext context, String title, int index, int selected) {
    final isSelected = index == selected;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ProfileBloc>().add(ChangeTabEvent(index));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
