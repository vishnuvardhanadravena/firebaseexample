import 'package:flutter/material.dart';

/// ===============================================================
/// AppLoader
/// ===============================================================
///
/// Global Loading Helper
///
/// Usage:
///
/// // Show Loader
/// AppLoader.show(context);
///
/// // Hide Loader
/// AppLoader.hide(context);
///
/// // Example
///
/// AppLoader.show(context);
///
/// try {
///   await controller.login();
/// } finally {
///   AppLoader.hide(context);
/// }
///
/// ===============================================================

class AppLoader {
  AppLoader._();

  static bool _isShowing = false;

  ///---------------------------------------------------------------
  /// Show Loader
  ///---------------------------------------------------------------
  static void show(BuildContext context, {String message = "Please wait..."}) {
    if (_isShowing) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: Container(
                width: 220,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),

                    const SizedBox(height: 20),

                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///---------------------------------------------------------------
  /// Hide Loader
  ///---------------------------------------------------------------
  static void hide(BuildContext context) {
    if (!_isShowing) return;

    Navigator.of(context, rootNavigator: true).pop();

    _isShowing = false;
  }
}
