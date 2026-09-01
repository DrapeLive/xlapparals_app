import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:xlapparals_app/core/routes/route_name.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/widgets/scan_overlay_widget.dart';

import '../blocs/scan_bloc.dart';
import '../blocs/scan_event.dart';
import '../blocs/scan_state.dart';

enum _CameraStatus { loading, ready, error }

class _CameraState {
  final _CameraStatus status;
  final String? errorMessage;
  const _CameraState.loading()
    : status = _CameraStatus.loading,
      errorMessage = null;
  const _CameraState.ready()
    : status = _CameraStatus.ready,
      errorMessage = null;
  const _CameraState.error(this.errorMessage) : status = _CameraStatus.error;
}

class ScanItemPage extends StatefulWidget {
  final int orderId;
  final int agentId;
  const ScanItemPage({super.key, required this.orderId, required this.agentId});

  @override
  State<ScanItemPage> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;

  final BarcodeScanner _barcodeScanner = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

  final AudioPlayer _audioPlayer = AudioPlayer();

  // ValueNotifier drives all camera UI — no setState needed anywhere
  final ValueNotifier<_CameraState> _cameraState = ValueNotifier(
    const _CameraState.loading(),
  );

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    context.read<ScanBloc>().add(ResetScanner());
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameraState.value = const _CameraState.loading();

    // Dispose old controller if reinitializing
    final old = _cameraController;
    _cameraController = null;
    await old?.dispose();

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _cameraState.value = const _CameraState.error(
          'No camera found on this device.',
        );
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      _cameraController = controller;
      await controller.startImageStream(_processCameraImage);

      _cameraState.value = const _CameraState.ready();
    } catch (e) {
      _cameraState.value = _CameraState.error('Camera failed to start: $e');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) {
        _isProcessing = false;
        return;
      }

      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isEmpty) {
        _isProcessing = false;
        return;
      }

      final qrCode = barcodes.first.rawValue;
      if (qrCode == null || qrCode.isEmpty) {
        _isProcessing = false;
        return;
      }

      await _cameraController?.stopImageStream();

      // Play beep on successful detection
      await _audioPlayer.play(AssetSource('sounds/beep.wav'));

      if (!mounted) return;

      context.read<ScanBloc>().add(
        ScanDetected(
          qrCode: qrCode,
          orderId: widget.orderId,
          agentId: widget.agentId,
        ),
      );
    } catch (_) {
      _isProcessing = false;
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;
    if (image.planes.isEmpty) return null;

    final rotation = switch (camera.sensorOrientation) {
      0 => InputImageRotation.rotation0deg,
      90 => InputImageRotation.rotation90deg,
      180 => InputImageRotation.rotation180deg,
      270 => InputImageRotation.rotation270deg,
      _ => InputImageRotation.rotation0deg,
    };

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> _restartScanner() async {
    if (!mounted) return;

    context.read<ScanBloc>().add(ResetScanner());
    _isProcessing = false;

    try {
      final controller = _cameraController;
      if (controller != null &&
          controller.value.isInitialized &&
          !controller.value.isStreamingImages) {
        await controller.startImageStream(_processCameraImage);
      }
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        controller?.stopImageStream().catchError((_) {});
        break;
      case AppLifecycleState.resumed:
        if (!_isProcessing) {
          _initCamera();
        }
        break;
      default:
        break;
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
              await showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                backgroundColor: Colors.transparent,
                builder: (_) => _OutOfStockSheet(
                  groupStock: state.data.groupStock,
                  onBackToOrder: () => context.go(
                    RouteNames.orderDetails,
                    extra: widget.orderId,
                  ),
                  onScanAnother: () async {
                    Navigator.pop(context);
                    await _restartScanner();
                  },
                ),
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

          if (state is ScanUnassigned) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.white,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.link_off_rounded,
                    color: Colors.orange.shade600,
                    size: 32,
                  ),
                ),
                title: const Text(
                  'Unassigned Item',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  'This item is not assigned to any order or agent. Please scan a different item.',
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _restartScanner();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Scan Another Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ScanError) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.white,
              builder: (_) => AlertDialog(
                title: const Text('The QR is Invalid'),
                actions: [
                  TextButton(
                    onPressed: () => context.go(
                      RouteNames.orderDetails,
                      extra: widget.orderId,
                    ),
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
              ),
            );
          }
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    context.go(RouteNames.orderDetails, extra: widget.orderId),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ValueListenableBuilder rebuilds only the camera area
                      // — the rest of the widget tree never rebuilds
                      ValueListenableBuilder<_CameraState>(
                        valueListenable: _cameraState,
                        builder: (context, state, _) {
                          return switch (state.status) {
                            _CameraStatus.loading => const ColoredBox(
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            _CameraStatus.error => ColoredBox(
                              color: Colors.black,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      state.errorMessage ?? 'Camera error',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: _initCamera,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _CameraStatus.ready => ClipRect(
                              child: SizedBox.expand(
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _cameraController!
                                        .value
                                        .previewSize!
                                        .height,
                                    height: _cameraController!
                                        .value
                                        .previewSize!
                                        .width,
                                    child: CameraPreview(_cameraController!),
                                  ),
                                ),
                              ),
                            ),
                          };
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
    WidgetsBinding.instance.removeObserver(this);
    _cameraState.dispose();
    _cameraController?.dispose();
    _barcodeScanner.close();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class _OutOfStockSheet extends StatelessWidget {
  final Map<String, dynamic> groupStock;
  final VoidCallback onBackToOrder;
  final VoidCallback onScanAnother;

  const _OutOfStockSheet({
    required this.groupStock,
    required this.onBackToOrder,
    required this.onScanAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.red.shade400,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Out of Stock',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This item is currently unavailable in all size groups.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          // Stock breakdown grid
          if (groupStock.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock by Size Group',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: groupStock.entries.map((entry) {
                      final qty = entry.value as num? ?? 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: qty > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: qty > 0
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: qty > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($qty)',
                              style: TextStyle(
                                fontSize: 11,
                                color: qty > 0
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBackToOrder,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    'Back to Order',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onScanAnother,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Scan Another QR',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
