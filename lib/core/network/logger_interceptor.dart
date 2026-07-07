import 'dart:convert';

import 'package:dio/dio.dart';

import '../../app/flavor/flavor_config.dart';

class LoggerInterceptor extends Interceptor {
  LoggerInterceptor();

  bool get _enableLogs => FlavorConfig.instance.enableLogs;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (_enableLogs) {
      _printHeader('REQUEST');

      print('URL      : ${options.uri}');
      print('METHOD   : ${options.method}');
      print('HEADERS  : ${jsonEncode(options.headers)}');

      if (options.queryParameters.isNotEmpty) {
        print('QUERY    : ${jsonEncode(options.queryParameters)}');
      }

      if (options.data != null) {
        print('BODY');
        print(const JsonEncoder.withIndent('  ').convert(options.data));
      }

      _printFooter();
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (_enableLogs) {
      _printHeader('RESPONSE');

      print('URL      : ${response.requestOptions.uri}');
      print('STATUS   : ${response.statusCode}');

      print('BODY');

      print(
        const JsonEncoder.withIndent('  ').convert(response.data),
      );

      _printFooter();
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (_enableLogs) {
      _printHeader('ERROR');

      print('URL      : ${err.requestOptions.uri}');
      print('STATUS   : ${err.response?.statusCode}');
      print('MESSAGE  : ${err.message}');

      if (err.response?.data != null) {
        print(
          const JsonEncoder.withIndent('  ').convert(err.response?.data),
        );
      }

      _printFooter();
    }

    handler.next(err);
  }

  void _printHeader(String title) {
    print('');
    print(
      '==================== $title ====================',
    );
  }

  void _printFooter() {
    print(
      '================================================',
    );
    print('');
  }
}