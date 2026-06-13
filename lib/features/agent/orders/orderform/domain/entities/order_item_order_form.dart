class OrderItemOrderForm {
  final int id;

  final int item;
  final int variant;

  final String sizeGroup;
  final String itemType;

  final String itemName;
  final String itemNameDisplay;

  final String itemPrice;
  final String itemPriceDisplay;

  final String variantImage;
  final String? variantImageDisplay;

  final String size;
  final String sizeDisplay;

  final int quantity;
  final int packedQuantity;
  final int pieceCount;

  const OrderItemOrderForm({
    required this.id,
    required this.item,
    required this.variant,
    required this.sizeGroup,
    required this.itemType,
    required this.itemName,
    required this.itemNameDisplay,
    required this.itemPrice,
    required this.itemPriceDisplay,
    required this.variantImage,
    required this.variantImageDisplay,
    required this.size,
    required this.sizeDisplay,
    required this.quantity,
    required this.packedQuantity,
    required this.pieceCount,
  });

  double get amount => double.tryParse(itemPrice)! * quantity * pieceCount;
}
