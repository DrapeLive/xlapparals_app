import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/core/cache/api_cache_service.dart';
import 'package:xlapparals_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:xlapparals_app/shared/services/local_cache_service.dart';
import 'package:xlapparals_app/shared/services/notification_service.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SecureStorageService storage;
  final UserStorageService userStorage;
  final ApiCacheService apiCache;
  final LocalCacheService localCache;
  final NotificationService notificationService;

  AuthBloc(
    this.loginUseCase,
    this.storage,
    this.userStorage,
    this.apiCache,
    this.localCache,
    this.notificationService,
  ) : super(const AuthInitial()) {
    on<LoginRequested>(_login);
    on<TogglePasswordVisibility>(_togglePasswordVisibility);
  }

  Future<void> _login(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading(obscurePassword: state.obscurePassword));

    try {
      final user = await loginUseCase(
        email: event.email,
        password: event.password,
      );

      await storage.saveTokens(
        access: user.accessToken,
        refresh: user.refreshToken,
      );

      await userStorage.saveData(
        isSuperuser: user.isSuperuser,
        business: null,
        role: user.role,
        userId: user.userId,
      );

      // Cache invalidation on login: a fresh session must never see data
      // cached by a previously signed-in account.
      apiCache.invalidateAll();
      await localCache.clearAll();

      emit(AuthSuccess(user, obscurePassword: state.obscurePassword));

      // Best-effort FCM token registration for push notifications; failures
      // are swallowed inside the service so login flow never blocks on it.
      unawaited(notificationService.registerDeviceToken());
    } on DioException catch (e) {
      emit(
        AuthError(
          obscurePassword: state.obscurePassword,
          _loginErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        AuthError(
          obscurePassword: state.obscurePassword,
          "Something went wrong",
        ),
      );
    }
  }

  String _loginErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['detail'] is String) {
      final detail = data['detail'] as String;
      if (detail.isNotEmpty) return detail;
    }
    return e.response?.statusCode == 401
        ? "Invalid email or password"
        : "Login failed. Check your connection and try again.";
  }

  void _togglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<AuthState> emit,
  ) {
    final currentValue = state.obscurePassword;

    if (state is AuthInitial) {
      emit(AuthInitial(obscurePassword: !currentValue));
    } else if (state is AuthLoading) {
      emit(AuthLoading(obscurePassword: !currentValue));
    } else if (state is AuthSuccess) {
      emit(
        AuthSuccess(
          (state as AuthSuccess).authUser,
          obscurePassword: !currentValue,
        ),
      );
    } else if (state is AuthError) {
      emit(
        AuthError((state as AuthError).message, obscurePassword: !currentValue),
      );
    }
  }
}
