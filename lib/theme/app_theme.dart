import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const primaryLight = Color(0xFF0066B3);
  static const primaryDark = Color(0xFF4B7BFF);
  static const secondaryLight = Color(0xFF004C99);
  static const secondaryDark = Color(0xFF2B5CFF);
  static const backgroundLight = Color(0xFFF5F6F8);
  static const backgroundDark = Color(0xFF1C1C1E);
  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF2C2C2E);
  static const errorColor = Color(0xFFFF453A);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      surface: surfaceLight,
      surfaceContainer: backgroundLight,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: Color(0xFF1B1D1F)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1B1D1F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EC)),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B1D1F),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1B1D1F),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF1B1D1F),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF666666),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EC),
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      surface: surfaceDark,
      surfaceContainer: backgroundDark,
      error: errorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF3A3A3C)),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF8E8E93),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3C),
      thickness: 1,
    ),
  );
} 