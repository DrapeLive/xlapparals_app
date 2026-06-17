abstract class OrderInvoiceEvent {}

class LoadOrderInvoice extends OrderInvoiceEvent {
  final int orderId;

  LoadOrderInvoice(this.orderId);
}

class DownloadInvoice extends OrderInvoiceEvent {
  final int orderId;

  DownloadInvoice(this.orderId);
}

class PrintInvoice extends OrderInvoiceEvent {
  final int orderId;

  PrintInvoice(this.orderId);
}

class ShareInvoice extends OrderInvoiceEvent {
  final int orderId;

  ShareInvoice(this.orderId);
}
