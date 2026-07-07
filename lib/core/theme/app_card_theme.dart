import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppCardTheme {
  AppCardTheme._();

  static CardThemeData lightCardTheme = CardThemeData(
    color: AppColors.lightCard,
    elevation: 1,
    shadowColor: Colors.black12,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static CardThemeData darkCardTheme = CardThemeData(
    color: AppColors.darkCard,
    elevation: 1,
    shadowColor: Colors.black26,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
}