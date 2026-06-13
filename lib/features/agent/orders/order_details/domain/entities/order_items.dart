class OrderItem {
  final int id;

  final int item;
  final int variant;

  final String itemName;
  final String itemPrice;

  final String variantImage;

  final String sizeGroup;
  final String itemType;

  final int quantity;
  final int pieceCount;

  const OrderItem({
    required this.id,
    required this.item,
    required this.variant,
    required this.itemName,
    required this.itemPrice,
    required this.variantImage,
    required this.sizeGroup,
    required this.itemType,
    required this.quantity,
    required this.pieceCount,
  });

  double get totalPrice => double.tryParse(itemPrice)! * quantity;
}
