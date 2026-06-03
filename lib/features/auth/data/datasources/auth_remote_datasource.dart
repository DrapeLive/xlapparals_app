import 'package:dio/dio.dart';
import 'package:xlapparals_app/core/constants/api_constants.dart';

import '../models/login_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasourceImpl(this.dio);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,
      data: {"email": email, "password": password},
    );

    return LoginResponseModel.fromJson(response.data);
  }
}
