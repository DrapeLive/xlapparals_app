import '../../domain/entities/auth_user.dart';

class LoginResponseModel extends AuthUser {
  const LoginResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.role,
    required super.userId,
    required super.isSuperuser,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json["access"],
      refreshToken: json["refresh"],
      role: json["role"],
      userId: json["user_id"],
      isSuperuser: json["is_superuser"],
    );
  }
}
