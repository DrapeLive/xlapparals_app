import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const String _roleKey = 'role';
  static const String _userIdKey = 'user_id';
  static const String _businessKey = 'business';
  static const String _isSuperuserKey = 'is_superuser';

  Future<void> saveData({
    required String role,
    required int userId,
    required String? business,
    required bool isSuperuser,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    await prefs.setInt(_userIdKey, userId);
    if (business == null) {
      await prefs.remove(_businessKey);
    } else {
      await prefs.setString(_businessKey, business);
    }
    await prefs.setBool(_isSuperuserKey, isSuperuser);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<String?> getBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_businessKey);
  }

  Future<bool?> getIsSuperuser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSuperuserKey);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_businessKey);
    await prefs.remove(_isSuperuserKey);
  }
}
