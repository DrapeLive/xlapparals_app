import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/profile/domain/repository/profile_repository.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(const ProfileState()) {
    on<LoadProfileEvent>(_loadProfile);
    on<ChangeTabEvent>(_changeTab);
  }

  Future<void> _loadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final agent = await repository.getProfile();

    emit(state.copyWith(isLoading: false, agent: agent));
  }

  void _changeTab(ChangeTabEvent event, Emitter<ProfileState> emit) {
    emit(state.copyWith(selectedTab: event.index));
  }
}
