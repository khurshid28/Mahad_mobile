import 'package:flutter/material.dart';
import 'package:test_app/core/const/const.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppConstant.primaryColor,
    scaffoldBackgroundColor: AppConstant.whiteColor,
    colorScheme: ColorScheme.light(
      primary: AppConstant.primaryColor,
      secondary: AppConstant.secondaryColor,
      surface: AppConstant.whiteColor,
      error: AppConstant.redColor,
      onPrimary: AppConstant.whiteColor,
      onSecondary: AppConstant.whiteColor,
      onSurface: AppConstant.blackColor,
      onError: AppConstant.whiteColor,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppConstant.whiteColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppConstant.blackColor),
      titleTextStyle: TextStyle(
        color: AppConstant.blackColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstant.primaryColor,
        foregroundColor: AppConstant.whiteColor,
        elevation: 2,
        shadowColor: AppConstant.primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    
    // Floating Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppConstant.primaryColor,
      foregroundColor: AppConstant.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppConstant.greyColor1.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppConstant.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppConstant.redColor, width: 1),
      ),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppConstant.primaryColor,
      circularTrackColor: AppConstant.primaryColor.withOpacity(0.2),
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppConstant.greyColor1,
      thickness: 1,
      space: 1,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppConstant.primaryColor,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    colorScheme: ColorScheme.dark(
      primary: AppConstant.primaryColor,
      secondary: AppConstant.secondaryColor,
      surface: const Color(0xFF2A2A2A),
      error: AppConstant.redColor,
      onPrimary: AppConstant.whiteColor,
      onSecondary: AppConstant.whiteColor,
      onSurface: AppConstant.whiteColor,
      onError: AppConstant.whiteColor,
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2A2A2A),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppConstant.whiteColor),
      titleTextStyle: TextStyle(
        color: AppConstant.whiteColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstant.primaryColor,
        foregroundColor: AppConstant.whiteColor,
        elevation: 2,
        shadowColor: AppConstant.primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    
    // Floating Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppConstant.primaryColor,
      foregroundColor: AppConstant.whiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3A),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppConstant.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppConstant.redColor, width: 1),
      ),
    ),
    
    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppConstant.primaryColor,
      circularTrackColor: AppConstant.primaryColor.withOpacity(0.2),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A3A3A),
      thickness: 1,
      space: 1,
    ),
  );
}
