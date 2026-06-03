class AuthUser {
  final String accessToken;
  final String refreshToken;
  final String role;
  final int userId;
  final bool isSuperuser;

  const AuthUser({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.userId,
    required this.isSuperuser,
  });
}
