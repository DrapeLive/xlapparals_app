import 'package:dio/dio.dart';

/// A single cached GET response with a fixed expiry.
///
/// Expiry timestamps are set once at `put` time and are NOT refreshed on
/// repeat cache hits, so a hot endpoint cannot keep itself alive past its TTL.
class _ApiCacheEntry {
  final dynamic data;
  final int? statusCode;
  final String? statusMessage;
  final Map<String, List<String>> headers;
  final DateTime expiresAt;

  _ApiCacheEntry({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.headers,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// In-memory TTL cache for GET responses, used through [ApiCacheInterceptor].
///
/// Keying:
///  * method + request path + canonicalized (sorted) query string,
///  * the `Authorization` header, so cache entries are scoped per logged-in
///    user and can never leak from one account to another.
///
/// Correctness rules:
///  * only `GET` requests are cached,
///  * binary/sensitive payloads (pdf, invoice, download, out-of-stock checks)
///    are never cached,
///  * mutations invalidate the whole cache via [ApiCacheInterceptor], so a
///    successful POST/PATCH/PUT/DELETE can never be followed by a stale read.
class ApiCacheService {
  static const Duration defaultTtl = Duration(minutes: 5);

  final Map<String, _ApiCacheEntry> _cache = {};

  /// TTL used for a request path. Semi-static resources get a longer window,
  /// hot/volatile ones a shorter one.
  Duration ttlFor(String path) {
    if (path.contains('/agents/profile/')) return const Duration(minutes: 10);
    if (path.contains('/transports/')) return const Duration(minutes: 30);
    if (path.contains('/items/by-qr/')) return const Duration(minutes: 2);
    if (path.contains('/orders/')) return const Duration(minutes: 5);
    if (path.contains('/customers/')) return const Duration(minutes: 5);
    return defaultTtl;
  }

  /// Whether a request is eligible for caching. Only safe, idempotent reads.
  bool shouldCache(RequestOptions options) {
    if (options.method != 'GET') return false;
    final path = options.path;
    if (path.contains('pdf') ||
        path.contains('invoice') ||
        path.contains('download') ||
        path.contains('out-of-stock')) {
      return false;
    }
    return true;
  }

  String _key(RequestOptions options) {
    final entries = options.queryParameters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final query = entries.map((e) => '${e.key}=${e.value}').join('&');
    final token = options.headers['Authorization'];
    return '${options.method}|${options.path}?$query|$token';
  }

  /// Returns a cached response for [options] or null when missing/expired.
  Response<dynamic>? get(RequestOptions options) {
    if (!shouldCache(options)) return null;
    final key = _key(options);
    final entry = _cache[key];
    if (entry == null) return null;
    _cache.remove(key);
    if (entry.isExpired) return null;
    return Response<dynamic>(
      requestOptions: options,
      data: entry.data,
      statusCode: entry.statusCode,
      statusMessage: entry.statusMessage,
      headers: Headers.fromMap(entry.headers),
    );
  }

  /// Stores a successful GET response, honouring TTL expiry (no sliding).
  void put(RequestOptions options, Response<dynamic> response) {
    if (!shouldCache(options)) return;
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      return;
    }
    final key = _key(options);
    final existing = _cache[key];
    if (existing != null && !existing.isExpired) return;
    _cache[key] = _ApiCacheEntry(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      headers: response.headers.map,
      expiresAt: DateTime.now().add(ttlFor(options.path)),
    );
    _trim();
  }

  /// Manual invalidation: drops every entry whose key contains [pathPrefix].
  void invalidatePrefix(String pathPrefix) {
    _cache.removeWhere((key, _) => key.contains(pathPrefix));
  }

  /// Manual invalidation: clears the entire cache.
  void invalidateAll() => _cache.clear();

  /// Bounded memory: once the map grows too large, drop expired entries.
  void _trim() {
    if (_cache.length > 200) {
      _cache.removeWhere((_, entry) => entry.isExpired);
    }
  }
}

/// Dio interceptor that serves and stores [ApiCacheService] entries.
///
/// MUST be added AFTER [AuthInterceptor] so the `Authorization` header is
/// already present when the cache key is built.
class ApiCacheInterceptor extends Interceptor {
  ApiCacheInterceptor(this.cache);

  final ApiCacheService cache;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Opt out entirely for a guaranteed fresh round-trip (e.g. pull-to-refresh).
    if (options.extra['bypassCache'] == true) {
      handler.next(options);
      return;
    }
    final cached = cache.get(options);
    if (cached != null) {
      handler.resolve(cached);
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final options = response.requestOptions;
    if (options.method == 'GET') {
      cache.put(options, response);
    } else if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // Successful mutation -> any cached row may now be stale.
      cache.invalidateAll();
    }
    handler.next(response);
  }
}