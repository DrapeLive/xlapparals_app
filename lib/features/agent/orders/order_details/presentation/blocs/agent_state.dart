import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';

class AgentState {
  final Agent? agent;
  final bool isLoading;

  const AgentState({this.agent, this.isLoading = false});

  AgentState copyWith({Agent? agent, bool? isLoading}) {
    return AgentState(
      agent: agent ?? this.agent,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
