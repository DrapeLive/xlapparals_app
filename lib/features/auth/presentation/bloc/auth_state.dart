import 'package:xlapparals_app/features/auth/domain/entities/auth_user.dart';

abstract class AuthState {
  final bool obscurePassword;

  const AuthState({this.obscurePassword = true});
}

class AuthInitial extends AuthState {
  const AuthInitial({super.obscurePassword});
}

class AuthLoading extends AuthState {
  const AuthLoading({required super.obscurePassword});
}

class AuthSuccess extends AuthState {
  final AuthUser authUser;
  const AuthSuccess(this.authUser, {required super.obscurePassword});
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message, {required super.obscurePassword});
}
