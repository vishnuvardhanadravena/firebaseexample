import 'package:flutter/material.dart';

import 'app_button_theme.dart';
import 'app_card_theme.dart';
import 'app_colors.dart';
import 'app_input_theme.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    fontFamily: 'Poppins',

    colorScheme: AppColors.lightColorScheme,

    scaffoldBackgroundColor: AppColors.lightBackground,

    textTheme: AppTextTheme.lightTextTheme,

    elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,

    outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,

    filledButtonTheme: AppButtonTheme.filledButtonTheme,

    textButtonTheme: AppButtonTheme.textButtonTheme,

    inputDecorationTheme: AppInputTheme.lightInputDecorationTheme,

    cardTheme: AppCardTheme.lightCardTheme,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),

    dividerColor: AppColors.divider,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    fontFamily: 'Poppins',

    colorScheme: AppColors.darkColorScheme,

    scaffoldBackgroundColor: AppColors.darkBackground,

    textTheme: AppTextTheme.darkTextTheme,

    elevatedButtonTheme: AppButtonTheme.elevatedButtonTheme,

    outlinedButtonTheme: AppButtonTheme.outlinedButtonTheme,

    filledButtonTheme: AppButtonTheme.filledButtonTheme,

    textButtonTheme: AppButtonTheme.textButtonTheme,

    inputDecorationTheme: AppInputTheme.darkInputDecorationTheme,

    cardTheme: AppCardTheme.darkCardTheme,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
    ),

    dividerColor: Colors.white24,
  );
}