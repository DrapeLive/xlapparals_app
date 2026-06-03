import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_event.dart';
import 'package:xlapparals_app/features/agent/home/presentation/blocs/bottom_nav/bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(const BottomNavState(selectedIndex: 1)) {
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}
