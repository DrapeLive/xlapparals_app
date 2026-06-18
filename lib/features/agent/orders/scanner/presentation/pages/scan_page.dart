import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/widgets/scan_overlay_widget.dart';

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

  bool _isProcessing = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
  }

  Future<void> _restartScanner() async {
    if (_isDisposed || !mounted) return;

    context.read<ScanBloc>().add(ResetScanner());

    _isProcessing = false;

    try {
      await _controller.start();
    } catch (_) {
      // Controller may already be stopped/disposed by the time this runs;
      // ignore rather than crash.
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(RouteNames.orderDetails, extra: widget.orderId);
        }
      },
      child: BlocListener<ScanBloc, ScanState>(
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
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return AlertDialog(
                  title: const Text('The QR is Invalid'),
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
          }
        },
        child: SafeArea(
          top: false,
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

                              if (_isProcessing) {
                                return;
                              }

                              if (capture.barcodes.isEmpty) {
                                return;
                              }

                              final barcode = capture.barcodes.first;
                              final qrCode = barcode.rawValue;
                              if (qrCode == null || qrCode.isEmpty) {
                                return;
                              }

                              _isProcessing = true;

                              try {
                                await _controller.stop();
                              } catch (_) {
                                // Controller might already be stopped/disposed
                                // by a near-simultaneous call; ignore.
                              }

                              if (!mounted || _isDisposed) return;

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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}
