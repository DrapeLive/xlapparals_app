import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:xlapparals_app/core/theme/app_colors.dart';

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

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _cameraController;

  final BarcodeScanner _barcodeScanner = BarcodeScanner(
    formats: [BarcodeFormat.qrCode],
  );

  final AudioPlayer _audioPlayer = AudioPlayer();

  final ValueNotifier<_CameraState> _cameraState = ValueNotifier(
    const _CameraState.loading(),
  );

  late final AnimationController _scanController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameraState.value = const _CameraState.loading();

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

      await _audioPlayer.play(AssetSource('sounds/beep.wav'));

      if (!mounted) return;

      Navigator.of(context).pop(qrCode);
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanController.dispose();
    _cameraState.dispose();
    _cameraController?.dispose();
    _barcodeScanner.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Scan QR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'FIND ITEM BY QR CODE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary, width: 3.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Text(
                                        state.errorMessage ?? 'Camera error',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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
                      if (_cameraState.value.status == _CameraStatus.ready)
                        IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _scanController,
                            builder: (context, _) => CustomPaint(
                              painter: _ScannerOverlayPainter(
                                lineOffset: _scanController.value,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'AWAITING SCAN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Align QR Code',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Position the item's QR code within the frame to find the exact item",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double lineOffset;

  _ScannerOverlayPainter({required this.lineOffset});

  @override
  void paint(Canvas canvas, Size size) {
    const frame = 240.0;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frame,
      height: frame,
    );

    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final dimPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(24),
        ),
      ),
    );
    canvas.drawPath(dimPath, dimPaint);

    const cornerLength = 32.0;
    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    for (final (dx, dy) in const [(-1.0, -1.0), (1.0, -1.0), (1.0, 1.0), (-1.0, 1.0)]) {
      final corner = dx < 0 ? rect.left : rect.right;
      final cornerY = dy < 0 ? rect.top : rect.bottom;
      canvas.drawLine(
        Offset(corner, cornerY),
        Offset(corner + dx * cornerLength, cornerY),
        cornerPaint,
      );
      canvas.drawLine(
        Offset(corner, cornerY),
        Offset(corner, cornerY + dy * cornerLength),
        cornerPaint,
      );
    }

    final scanY = rect.top + lineOffset * rect.height;
    final scanPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.35)
      ..strokeWidth = 2.5;
    canvas.drawLine(
      Offset(rect.left + 6, scanY),
      Offset(rect.right - 6, scanY),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter oldDelegate) =>
      oldDelegate.lineOffset != lineOffset;
}