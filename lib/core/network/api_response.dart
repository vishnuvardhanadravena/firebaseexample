/// Generic API Response Wrapper
///
/// Usage:
/// return ApiResponse.success(data);
/// return ApiResponse.failure("Something went wrong");
library;

class ApiResponse<T> {
  const ApiResponse._({
    this.data,
    this.message,
    this.statusCode,
    required this.isSuccess,
  });

  /// Response Data
  final T? data;

  /// Server Message
  final String? message;

  /// HTTP Status Code
  final int? statusCode;

  /// Success / Failure
  final bool isSuccess;

  /// Success Factory
  factory ApiResponse.success(
    T data, {
    String? message,
    int? statusCode,
  }) {
    return ApiResponse._(
      data: data,
      message: message,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  /// Failure Factory
  factory ApiResponse.failure(
    String message, {
    int? statusCode,
    T? data,
  }) {
    return ApiResponse._(
      data: data,
      message: message,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  @override
  String toString() {
    return '''
ApiResponse(
  success: $isSuccess,
  statusCode: $statusCode,
  message: $message,
  data: $data,
)
''';
  }
}