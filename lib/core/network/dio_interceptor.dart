import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Connection Timeout',
          ),
        );
        return;

      case DioExceptionType.sendTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Send Timeout',
          ),
        );
        return;

      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Receive Timeout',
          ),
        );
        return;

      case DioExceptionType.connectionError:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'No Internet Connection',
          ),
        );
        return;

      case DioExceptionType.badCertificate:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Bad Certificate',
          ),
        );
        return;

      case DioExceptionType.cancel:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Request Cancelled',
          ),
        );
        return;

      case DioExceptionType.badResponse:
        _handleStatusCode(err, handler);
        return;

      case DioExceptionType.unknown:
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Unexpected Error',
          ),
        );
        return;
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _handleStatusCode(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final statusCode = err.response?.statusCode;

    String message;

    switch (statusCode) {
      case 400:
        message = 'Bad Request';
        break;

      case 401:
        message = 'Unauthorized';
        break;

      case 403:
        message = 'Forbidden';
        break;

      case 404:
        message = 'Resource Not Found';
        break;

      case 409:
        message = 'Conflict';
        break;

      case 422:
        message = 'Validation Error';
        break;

      case 500:
        message = 'Internal Server Error';
        break;

      case 503:
        message = 'Service Unavailable';
        break;

      default:
        message = 'Something went wrong';
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: message,
      ),
    );
  }
}