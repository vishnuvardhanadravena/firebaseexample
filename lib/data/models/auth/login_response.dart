

import 'user_model.dart';

class LoginResponse {
  const LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  final bool status;

  final String message;

  final String token;

  final UserModel user;

  factory LoginResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json["data"] ?? {};

    return LoginResponse(
      status: json["status"] ?? false,

      message: json["message"] ?? "",

      token: data["token"] ?? "",

      user: UserModel.fromJson(
        data["user"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": {
        "token": token,
        "user": user.toJson(),
      },
    };
  }

  LoginResponse copyWith({
    bool? status,
    String? message,
    String? token,
    UserModel? user,
  }) {
    return LoginResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}