import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

import 'agent_event.dart';
import 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  final UserStorageService storage;

  AgentBloc(this.storage) : super(const AgentState()) {
    on<LoadAgent>(_loadAgent);
  }

  Future<void> _loadAgent(LoadAgent event, Emitter<AgentState> emit) async {
    emit(state.copyWith(isLoading: true));

    final agent = await storage.getAgent();

    emit(state.copyWith(agent: agent, isLoading: false));
  }
}
