import 'package:dio/dio.dart';
import 'package:flavor/core/database/secure_storage_service.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';



class AuthRepository {
  AuthRepository({
    required this._dioClient,
    required this._secureStorage,
  });

  final DioClient _dioClient;

  final AppSecureStorage _secureStorage;

  
  Future<ApiResponse<LoginResponse>> login({
    required LoginRequest request,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,

        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      await _secureStorage.saveToken(loginResponse.token);

      return ApiResponse.success(loginResponse);
    } on DioException catch (e) {
      return ApiResponse.failure(e.message ?? "Login Failed");
    } catch (e) {
      return ApiResponse.failure(e.toString());
    }
  }
 
  Future<void> logout() async {
    await _secureStorage.deleteToken();
  }

  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }
}
