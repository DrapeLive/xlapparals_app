import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persistent, JSON-backed cache stored in SharedPreferences.
///
/// Purpose: "stale-while-revalidate" (SWR) caching of the item catalog and
/// order history so screens render instantly from the last known-good data
/// while the fresh copy is fetched in the background.
///
/// Design:
///  * Every value is a JSON object: `{"savedAt": <ISO-8601>, "data": <value>}`.
///  * Stale data is still returned (never nulled on read), but the caller can
///    compare [savedAt] against a stale horizon and decide to revalidate.
///  * With no persistent expiry, deletion is explicit: [clearAll] on logout /
///    login and a per-key [remove].
class LocalCacheService {
  static const String _keyPrefix = 'lc_';

  /// Reads back the `data` payload for [key], or null when absent.
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_keyPrefix$key');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded['data'];
    } catch (_) {
      // Corrupt payload - drop it so it never resurfaces.
      await prefs.remove('$_keyPrefix$key');
      return null;
    }
  }

  /// Writes [data] (anything jsonEncode-able) under [key], stamping savedAt.
  Future<void> write(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_keyPrefix$key',
      jsonEncode({
        'savedAt': DateTime.now().toIso8601String(),
        'data': data,
      }),
    );
  }

  /// Timestamp (ISO-8601) of when [key] was last written, or null.
  Future<DateTime?> savedAt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_keyPrefix$key');
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return DateTime.parse(decoded['savedAt'] as String);
    } catch (_) {
      return null;
    }
  }

  /// Removes a single cached key.
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_keyPrefix$key');
  }

  /// Clears every cached key (used on logout / fresh login).
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().toList()) {
      if (key.startsWith(_keyPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}