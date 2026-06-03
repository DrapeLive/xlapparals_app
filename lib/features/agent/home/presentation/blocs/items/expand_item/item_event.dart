abstract class ItemEvent {}

class ToggleItemExpansion extends ItemEvent {
  final String itemId;

  ToggleItemExpansion(this.itemId);
}
