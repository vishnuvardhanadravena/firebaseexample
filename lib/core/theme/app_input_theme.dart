import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppInputTheme {
  AppInputTheme._();

  static const double _radius = 12;

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: BorderSide(
        color: color,
        width: 1.2,
      ),
    );
  }

  /// Light Theme
  static InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,

    isDense: true,

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),

    hintStyle: const TextStyle(
      color: AppColors.textHint,
      fontSize: 14,
    ),

    labelStyle: const TextStyle(
      color: AppColors.textSecondary,
      fontSize: 14,
    ),

    floatingLabelStyle: const TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),

    prefixIconColor: AppColors.textSecondary,

    suffixIconColor: AppColors.textSecondary,

    enabledBorder: _border(AppColors.border),

    focusedBorder: _border(AppColors.primary),

    disabledBorder: _border(AppColors.border),

    errorBorder: _border(AppColors.error),

    focusedErrorBorder: _border(AppColors.error),

    border: _border(AppColors.border),
  );

  /// Dark Theme
  static InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,

    isDense: true,

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),

    hintStyle: const TextStyle(
      color: Colors.white54,
      fontSize: 14,
    ),

    labelStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 14,
    ),

    floatingLabelStyle: const TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),

    prefixIconColor: Colors.white70,

    suffixIconColor: Colors.white70,

    enabledBorder: _border(Colors.white24),

    focusedBorder: _border(AppColors.primary),

    disabledBorder: _border(Colors.white24),

    errorBorder: _border(AppColors.error),

    focusedErrorBorder: _border(AppColors.error),

    border: _border(Colors.white24),
  );
}