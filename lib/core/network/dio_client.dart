import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/cache/api_cache_service.dart';
import 'package:xlapparals_app/core/network/dio_interceptor.dart';
import 'package:xlapparals_app/shared/services/secure_storage_service.dart';
import '../constants/api_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient(SecureStorageService storage, ApiCacheService apiCache) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage, dio));
    dio.interceptors.add(ApiCacheInterceptor(apiCache));
  }
}
