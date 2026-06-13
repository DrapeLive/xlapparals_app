import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlapparals_app/features/agent/profile/domain/entities/agent.dart';

class UserStorageService {
  static const String _roleKey = 'role';
  static const String _userIdKey = 'user_id';
  static const String _businessKey = 'business';
  static const String _isSuperuserKey = 'is_superuser';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _contactKey = 'contact';
  static const String _totalCustomersKey = 'total_customers';
  static const String _idKey = "id";

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

  Future<void> saveAgent({
    required int id,
    required String role,
    required int userId,
    required String username,
    required String email,
    required String contact,
    required int totalCustomers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_contactKey, contact);
    await prefs.setInt(_totalCustomersKey, totalCustomers);
    await prefs.setInt(_idKey, id);
  }

  Future<Agent?> getAgent() async {
    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString(_roleKey);
    final userId = prefs.getInt(_userIdKey);
    final username = prefs.getString(_usernameKey);
    final email = prefs.getString(_emailKey);
    final contact = prefs.getString(_contactKey);
    final totalCustomers = prefs.getInt(_totalCustomersKey);
    final id = prefs.getInt(_idKey);

    if (role == null ||
        userId == null ||
        username == null ||
        email == null ||
        contact == null ||
        totalCustomers == null ||
        id == null) {
      return null;
    }

    return Agent(
      id: id,
      role: role,
      userId: userId,
      username: username,
      email: email,
      contact: contact,
      totalCustomers: totalCustomers,
    );
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

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_businessKey);
    await prefs.remove(_isSuperuserKey);

    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_contactKey);
    await prefs.remove(_totalCustomersKey);
    await prefs.remove(_idKey);
  }
}
