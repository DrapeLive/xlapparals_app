abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class ChangeTabEvent extends ProfileEvent {
  final int index;

  ChangeTabEvent(this.index);
}
