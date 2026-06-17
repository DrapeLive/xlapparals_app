import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/orderform/domain/entities/order_form.dart';
import 'package:flutter/services.dart';
import '../../domain/repositories/order_form_repository.dart';
import 'order_form_event.dart';
import 'order_form_states.dart';

import 'package:file_saver/file_saver.dart';
import 'package:intl/intl.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class OrderInvoiceBloc extends Bloc<OrderInvoiceEvent, OrderInvoiceState> {
  final OrderInvoiceRepository repository;

  OrderInvoiceBloc(this.repository) : super(OrderInvoiceInitial()) {
    on<LoadOrderInvoice>(_loadInvoice);
    on<DownloadInvoice>(_downloadInvoice);
    on<PrintInvoice>(_printInvoice);
    on<ShareInvoice>(_shareInvoice);
  }

  Future<void> savePdfToDownloads({
    required Uint8List pdfBytes,
    required int orderId,
  }) async {
    await FileSaver.instance.saveFile(
      name: 'invoice_$orderId',
      bytes: pdfBytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
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

      final invoice = await repository.getInvoice(event.orderId);

      final pdfBytes = await _generateInvoicePdf(invoice);

      await savePdfToDownloads(pdfBytes: pdfBytes, orderId: event.orderId);

      emit(OrderInvoiceLoaded(invoice));
    } catch (e) {
      emit(OrderInvoiceError(e.toString()));
    }
  }

  Future<void> _shareInvoice(
    ShareInvoice event,
    Emitter<OrderInvoiceState> emit,
  ) async {
    try {
      emit(OrderInvoicePrinting());

      final invoice = await repository.getInvoice(event.orderId);

      final pdfBytes = await _generateInvoicePdf(invoice);

      final tempDir = await getTemporaryDirectory();

      final file = File('${tempDir.path}/invoice_${event.orderId}.pdf');

      await file.writeAsBytes(pdfBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Invoice #${event.orderId}',
          subject: 'Invoice #${event.orderId}',
        ),
      );

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
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );
    final gstAmount = invoice.totalPrice * invoice.gstRate / 100;

    final grandTotal = invoice.totalPrice + gstAmount;

    final totalPieces = invoice.items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity * item.pieceCount),
    );

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    final dio = Dio();

    pw.MemoryImage? logoImage;

    try {
      final response = await dio.get<List<int>>(
        invoice.brand.logoUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        logoImage = pw.MemoryImage(Uint8List.fromList(response.data!));
      }
    } catch (e) {}

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(
                logoImage!,
                width: 100,
                height: 100,
                fit: pw.BoxFit.contain,
              ),
              pw.Column(
                children: [
                  pw.Text(
                    invoice.brand.name,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(invoice.brand.addressLine1),
                  if (invoice.brand.addressLine2 != null)
                    pw.Text(invoice.brand.addressLine2!),
                  pw.Text(invoice.brand.phone),
                  pw.Text(invoice.brand.email),
                  pw.Text("GST : ${invoice.brand.gst}"),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 10),
          pw.Divider(color: PdfColors.black, height: 4),

          pw.SizedBox(height: 10),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "ORDER FORM",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Column(
                children: [
                  pw.Text("Order Form #${invoice.id}"),

                  pw.Text("Status : ${invoice.status}"),

                  pw.Text(
                    "Date : ${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}",
                  ),
                ],
              ),
            ],
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
              final price = double.tryParse(item.itemPrice) ?? 0.0;
              final amount = price * item.quantity * item.pieceCount;

              return [
                item.itemName,
                item.sizeGroup,
                item.itemPrice,
                "${item.quantity} x ${item.pieceCount}",
                currencyFormatter.format(amount),
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
                pw.Text(
                  "SUBTOTAL :   ${currencyFormatter.format(invoice.totalPrice)}",
                ),
                pw.Text(
                  "GST @ ${invoice.gstRate}% : ${currencyFormatter.format(gstAmount)}",
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "TOTAL : ${currencyFormatter.format(grandTotal)}",
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
