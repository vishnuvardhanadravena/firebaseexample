import 'package:flutter/material.dart';

import '../../../core/network/api_response.dart';
import '../../models/auth/login_request.dart';
import '../../models/auth/login_response.dart';
import '../../repositories/auth_repository.dart';

/// ===============================================================
/// AuthController
/// ===============================================================
///
/// Handles:
/// • Login
/// • Logout
/// • Loading
/// • Error Message
///
/// Usage:
///
/// final controller = getIt<AuthController>();
///
/// await controller.login(
///   email: "abc@gmail.com",
///   password: "123456",
/// );
///
/// if(controller.isLoggedIn){
///
/// }
///
/// ===============================================================

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? _error;

  String? get error => _error;

  LoginResponse? _user;

  LoginResponse? get user => _user;

  ///---------------------------------------------------------------
  /// Login
  ///---------------------------------------------------------------
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.login(
      request: LoginRequest(
        email: email,
        password: password,
      ),
    );

    _isLoading = false;

    if (response.isSuccess) {
      _user = response.data;

      _isLoggedIn = true;

      notifyListeners();

      return true;
    }

    _error = response.message;

    notifyListeners();

    return false;
  }

  ///---------------------------------------------------------------
  /// Logout
  ///---------------------------------------------------------------
  Future<void> logout() async {
    await _repository.logout();

    _user = null;

    _isLoggedIn = false;

    notifyListeners();
  }

  ///---------------------------------------------------------------
  /// Check Login
  ///---------------------------------------------------------------
  Future<void> checkLoginStatus() async {
    _isLoggedIn =
        await _repository.isLoggedIn();

    notifyListeners();
  }
}