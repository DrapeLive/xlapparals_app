import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';

class ProfileState {
  final bool isLoading;
  final Agent? agent;
  final int selectedTab;

  const ProfileState({
    this.isLoading = false,
    this.agent,
    this.selectedTab = 0,
  });

  ProfileState copyWith({bool? isLoading, Agent? agent, int? selectedTab}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      agent: agent ?? this.agent,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
