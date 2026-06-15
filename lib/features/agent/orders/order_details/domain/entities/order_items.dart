class OrderDetailsItem {
  final int id;

  final int item;
  final int variant;

  final String itemName;
  final String itemNameDisplay;

  final String itemPrice;
  final String itemPriceDisplay;

  final String variantImage;
  final String? variantImageDisplay;

  final String sizeGroup;
  final String itemType;

  final String size;
  final String sizeDisplay;

  final int quantity;
  final int packedQuantity;
  final int pieceCount;

  const OrderDetailsItem({
    required this.id,
    required this.item,
    required this.variant,
    required this.itemName,
    required this.itemNameDisplay,
    required this.itemPrice,
    required this.itemPriceDisplay,
    required this.variantImage,
    this.variantImageDisplay,
    required this.sizeGroup,
    required this.itemType,
    required this.size,
    required this.sizeDisplay,
    required this.quantity,
    required this.packedQuantity,
    required this.pieceCount,
  });

  double get unitPrice => double.tryParse(itemPrice) ?? 0.0;

  double get totalPrice => unitPrice * quantity;
}
