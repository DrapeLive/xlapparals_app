import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/domain/usecases/check_usecase.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/blocs/scan_event.dart';
import 'package:xlapparals_app/features/agent/orders/scanner/presentation/blocs/scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final CheckQrUsecase checkQrUsecase;

  ScanBloc(this.checkQrUsecase) : super(ScanReady()) {
    on<ScanDetected>(_onScanDetected);
    on<ResetScanner>(_onResetScanner);
  }

  Future<void> _onScanDetected(
    ScanDetected event,
    Emitter<ScanState> emit,
  ) async {
    emit(ScanLoading());

    try {
      final result = await checkQrUsecase(
        qrCode: event.qrCode,
        orderId: event.orderId,
      );

      emit(ScanSuccess(data: result, qrCode: event.qrCode));
    } catch (e) {
      emit(ScanError(e.toString()));

      emit(ScanReady());
    }
  }

  void _onResetScanner(ResetScanner event, Emitter<ScanState> emit) {
    emit(ScanReady());
  }
}
