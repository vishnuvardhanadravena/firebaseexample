import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._tokenProvider,
    required Future<void> Function()? onUnauthorized,
  })  : _onUnauthorized = onUnauthorized;

  final Future<String?> Function() _tokenProvider;

  final Future<void> Function()? _onUnauthorized;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();

    options.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
    });

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await _onUnauthorized?.call();
    }

    handler.next(err);
  }
}
// dio.interceptors.add(
//   AuthInterceptor(
//     tokenProvider: () async {
//       return await storage.readToken();
//     },
//     onUnauthorized: () async {
//       await storage.clear();

//       // Navigate to Login Screen
//     },
//   ),
// );