class BottomNavState {
  final int selectedIndex;

  const BottomNavState({required this.selectedIndex});

  BottomNavState copyWith({int? selectedIndex}) {
    return BottomNavState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
