import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';

import '../../domain/repositories/order_form_repository.dart';
import 'order_form_event.dart';
import 'order_form_states.dart';

class OrderInvoiceBloc extends Bloc<OrderInvoiceEvent, OrderInvoiceState> {
  final OrderInvoiceRepository repository;

  OrderInvoiceBloc(this.repository) : super(OrderInvoiceInitial()) {
    on<LoadOrderInvoice>(_loadInvoice);
    on<DownloadInvoice>(_downloadInvoice);
    on<PrintInvoice>(_printInvoice);
  }

  Future<void> _loadInvoice(
    LoadOrderInvoice event,
    Emitter<OrderInvoiceState> emit,
  ) async {
    emit(OrderInvoiceLoading());

    try {
      final invoice = await repository.getInvoice(event.orderId);

      emit(OrderInvoiceLoaded(invoice));
    } catch (e) {
      emit(OrderInvoiceError(e.toString()));
    }
  }

  Future<void> _downloadInvoice(
    DownloadInvoice event,
    Emitter<OrderInvoiceState> emit,
  ) async {
    try {
      emit(OrderInvoiceDownloading());

      await repository.downloadPdf(event.orderId);

      final invoice = await repository.getInvoice(event.orderId);

      emit(OrderInvoiceLoaded(invoice));
    } catch (e) {
      emit(OrderInvoiceError(e.toString()));
    }
  }

  Future<void> _printInvoice(
    PrintInvoice event,
    Emitter<OrderInvoiceState> emit,
  ) async {
    try {
      emit(OrderInvoicePrinting());

      final invoice = await repository.getInvoice(event.orderId);

      final pdf = await _generateInvoicePdf(invoice);

      await Printing.layoutPdf(onLayout: (_) async => pdf);

      emit(OrderInvoiceLoaded(invoice));
    } catch (e) {
      emit(OrderInvoiceError(e.toString()));
    }
  }

  Future<Uint8List> _generateInvoicePdf(OrderInvoice invoice) async {
    final pdf = pw.Document();

    final gstAmount = invoice.totalPrice * invoice.gstRate / 100;

    final grandTotal = invoice.totalPrice + gstAmount;

    final totalPieces = invoice.items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity * item.pieceCount),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              invoice.brand.name,
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Center(child: pw.Text(invoice.brand.addressLine1)),

          if (invoice.brand.addressLine2 != null)
            pw.Center(child: pw.Text(invoice.brand.addressLine2!)),

          pw.Center(child: pw.Text(invoice.brand.phone)),

          pw.Center(child: pw.Text(invoice.brand.email)),

          pw.Center(child: pw.Text("GST : ${invoice.brand.gst}")),

          pw.SizedBox(height: 20),

          pw.Center(
            child: pw.Text(
              "ORDER FORM",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Order Form #${invoice.id}"),

          pw.Text("Status : ${invoice.status}"),

          pw.Text(
            "Date : ${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}",
          ),

          pw.SizedBox(height: 20),

          pw.Text(
            "CUSTOMER",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),

          pw.Text(invoice.customer.name),
          pw.Text(invoice.customer.address),
          pw.Text(invoice.customer.contact),

          pw.SizedBox(height: 20),

          pw.Text("AGENT", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

          pw.Text(invoice.agent.username),
          pw.Text(invoice.agent.contact),

          pw.SizedBox(height: 20),

          pw.TableHelper.fromTextArray(
            headers: const ["Item", "Size", "Price", "Qty", "Amount"],
            data: invoice.items.map((item) {
              final amount = item.itemPrice * item.quantity * item.pieceCount;

              return [
                item.itemName,
                item.sizeGroup,
                item.itemPrice,
                "${item.quantity} x ${item.pieceCount}",
                amount,
              ];
            }).toList(),
          ),

          pw.SizedBox(height: 20),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("TOTAL PIECES : $totalPieces"),
                pw.Text("SUBTOTAL : ₹${invoice.totalPrice.toStringAsFixed(2)}"),
                pw.Text(
                  "GST @ ${invoice.gstRate}% : ₹${gstAmount.toStringAsFixed(2)}",
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "TOTAL : ₹${grandTotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 30),

          pw.Center(child: pw.Text("Thank you for your business!")),
        ],
      ),
    );

    final bytes = await pdf.save();
    return Uint8List.fromList(bytes);
  }
}
