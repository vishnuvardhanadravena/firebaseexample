import 'package:flutter/material.dart';

/// ===============================================================
/// AppDialog
/// ===============================================================
///
/// Centralized Dialog Helper
///
/// Usage:
///
/// await AppDialog.info(
///   context,
///   title: "Information",
///   message: "Profile Updated Successfully",
/// );
///
/// await AppDialog.error(
///   context,
///   title: "Error",
///   message: "Something went wrong",
/// );
///
/// final result = await AppDialog.confirm(
///   context,
///   title: "Delete",
///   message: "Do you want to delete this item?",
/// );
///
/// if(result == true){
///   deleteItem();
/// }
///
/// ===============================================================

class AppDialog {
  AppDialog._();

  ///---------------------------------------------------------------
  /// Information Dialog
  ///---------------------------------------------------------------
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = "OK",
  }) {
    return _show(
      context,
      title: title,
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }

  ///---------------------------------------------------------------
  /// Error Dialog
  ///---------------------------------------------------------------
  static Future<void> error(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = "OK",
  }) {
    return _show(
      context,
      title: title,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }

  ///---------------------------------------------------------------
  /// Success Dialog
  ///---------------------------------------------------------------
  static Future<void> success(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = "OK",
  }) {
    return _show(
      context,
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText),
        ),
      ],
    );
  }

  ///---------------------------------------------------------------
  /// Confirmation Dialog
  ///---------------------------------------------------------------
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = "Yes",
    String cancelText = "No",
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  ///---------------------------------------------------------------
  /// Common Dialog
  ///---------------------------------------------------------------
  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required List<Widget> actions,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }
}