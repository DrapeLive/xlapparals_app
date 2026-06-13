import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_bloc.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_event.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/blocs/profile/profile_state.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/widgets/profile_tab.dart';
import 'package:xlapparals_app/features/agent/profile/presentation/widgets/signout_button.dart';
import 'package:xlapparals_app/shared/pages/error_page.dart';

import '../widgets/customer_tile.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.agentHome),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.agent == null) {
              return ErrorPage(
                message: "No Profile Found!",
                onRetry: () {
                  context.read<ProfileBloc>().add(LoadProfileEvent());
                },
              );
            }

            final agent = state.agent!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        agent.username.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified_user, size: 12),
                            Text(agent.role, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ProfileTab(),
                  SizedBox(height: 30),
                  ProfileCard(profile: agent),
                  const SizedBox(height: 16),
                  CustomerTile(count: agent.totalCustomers),
                  SizedBox(height: 15),
                  SignOutButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
