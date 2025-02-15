import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      platform: TargetPlatform.iOS,
      fontFamily: '.SF Pro Display',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: '.SF Pro Display',
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(fontFamily: '.SF Pro Text'),
        bodyMedium: TextStyle(fontFamily: '.SF Pro Text'),
        bodySmall: TextStyle(fontFamily: '.SF Pro Text'),
        labelLarge: TextStyle(fontFamily: '.SF Pro Text'),
        labelMedium: TextStyle(fontFamily: '.SF Pro Text'),
        labelSmall: TextStyle(fontFamily: '.SF Pro Text'),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
} 