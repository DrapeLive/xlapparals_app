import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/widgets/scan_overlay_widget.dart';
import 'package:xlapparals_app/shared/widgets/app_toast.dart';

import '../blocs/scan_bloc.dart';
import '../blocs/scan_event.dart';
import '../blocs/scan_state.dart';

class ScanItemPage extends StatefulWidget {
  final int orderId;
  final int agentId;
  const ScanItemPage({super.key, required this.orderId, required this.agentId});

  @override
  State<ScanItemPage> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
  }

  Future<void> _restartScanner() async {
    context.read<ScanBloc>().add(ResetScanner());

    await _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) async {
        if (state is ScanSuccess) {
          if (state.data.outOfStock) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Out Of Stock'),
                  content: const Text('This item is currently out of stock.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.go(
                          RouteNames.orderDetails,
                          extra: widget.orderId,
                        );
                      },
                      child: const Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        await _restartScanner();
                      },
                      child: const Text('Scan Another Item'),
                    ),
                  ],
                );
              },
            );
          } else {
            context.go(
              RouteNames.orderItems,
              extra: {
                'orderId': widget.orderId,
                'qrCode': state.qrCode,
                'agentId': widget.agentId,
              },
            );
          }
        }

        if (state is ScanError) {
          AppToast.show(context, message: state.message, type: ToastType.error);

          await _restartScanner();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(RouteNames.orderDetails, extra: widget.orderId);
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 24),

            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BlocBuilder<ScanBloc, ScanState>(
                    builder: (context, state) {
                      return MobileScanner(
                        controller: _controller,
                        onDetect: (capture) async {
                          if (state is ScanLoading) {
                            return;
                          }

                          final barcode = capture.barcodes.firstOrNull;

                          final qrCode = barcode?.rawValue;
                          if (qrCode == null || qrCode.isEmpty) {
                            return;
                          }

                          await _controller.stop();

                          if (!context.mounted) return;

                          context.read<ScanBloc>().add(
                            ScanDetected(
                              qrCode: qrCode,
                              orderId: widget.orderId,
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const ScannerOverlay(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            BlocBuilder<ScanBloc, ScanState>(
              builder: (context, state) {
                final text = state is ScanLoading
                    ? 'VERIFYING...'
                    : 'AWAITING SCAN';

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            const Text(
              "Align QR Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Position the item's QR code within the frame to add it to the order",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
