import 'package:dio/dio.dart';
import 'package:flavor/core/constants/api_constants.dart';
import 'package:flavor/core/network/auth_interceptor.dart';
import 'package:flavor/core/network/dio_interceptor.dart';
import 'package:flavor/core/network/logger_interceptor.dart';


class DioClient {
  DioClient({
    required Future<String?> Function() tokenProvider,
    required Future<void> Function() onUnauthorized,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType,
            validateStatus: (status) => status != null && status < 500,
          ),
        ) {
    _dio.interceptors.addAll([
      LoggerInterceptor(),
      AuthInterceptor(
        tokenProvider: tokenProvider,
        onUnauthorized: onUnauthorized,//(){}
      ),
      DioInterceptor(),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) {
    return _dio.put<T>(
      path,
      data: data,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> multipart<T>(
    String path, {
    required FormData formData,
  }) {
    return _dio.post<T>(
      path,
      data: formData,
    );
  }
}