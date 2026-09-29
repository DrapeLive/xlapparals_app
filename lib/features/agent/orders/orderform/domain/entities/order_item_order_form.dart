class OrderItemOrderForm {
  final int id;

  final int item;
  final int variant;

  final String? variantDisplayOrder;

  final String sizeGroup;
  final String itemType;

  final String itemName;
  final String itemNameDisplay;

  final String? itemPrice;
  final String itemPriceDisplay;

  final String variantImage;
  final String? variantImageDisplay;

  final String size;
  final String sizeDisplay;

  final int quantity;
  final int packedQuantity;
  final int pieceCount;

  const OrderItemOrderForm({
    this.variantDisplayOrder,
    required this.id,
    required this.item,
    required this.variant,
    this.sizeGroup = '',
    this.itemType = '',
    this.itemName = '',
    this.itemNameDisplay = '',
    this.itemPrice,
    this.itemPriceDisplay = '',
    this.variantImage = '',
    this.variantImageDisplay,
    this.size = '',
    this.sizeDisplay = '',
    this.quantity = 0,
    this.packedQuantity = 0,
    this.pieceCount = 0,
  });

  double get amount => (double.tryParse(itemPrice ?? '') ?? 0) * quantity * pieceCount;
}
