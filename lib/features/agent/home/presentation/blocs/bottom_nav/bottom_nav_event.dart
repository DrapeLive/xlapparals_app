abstract class BottomNavEvent {}

class ChangeTabEvent extends BottomNavEvent {
  final int index;
  ChangeTabEvent(this.index);
}
