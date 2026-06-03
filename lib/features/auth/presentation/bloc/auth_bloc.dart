import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xlapparals_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:xlapparals_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';
import 'package:xlapparals_app/shared/services/user_storage_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SecureStorageService storage;
  final UserStorageService userStorage;

  AuthBloc(this.loginUseCase, this.storage, this.userStorage)
    : super(const AuthInitial()) {
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

      emit(AuthSuccess(user, obscurePassword: state.obscurePassword));
    } on DioException catch (e) {
      emit(AuthError(obscurePassword: state.obscurePassword, "Login failed"));
    } catch (_) {
      emit(
        AuthError(
          obscurePassword: state.obscurePassword,
          "Something went wrong",
        ),
      );
    }
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
