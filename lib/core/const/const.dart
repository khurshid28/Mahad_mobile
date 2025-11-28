import 'package:flutter/material.dart';

class AppConstant {
  // Primary colors - Green theme
  static const Color primaryColor = Color(0xFF53B175);
  static const Color primaryLight = Color(0xFF7BC99E);
  static const Color primaryDark = Color(0xFF3E8E5F);
  static const Color secondaryColor = Color(0xFF47F266);
  
  // Accent colors
  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentPurple = Color(0xFF8854D0);
  static const Color accentBlue = Color(0xFF4B7BEC);
  static const Color accentPink = Color(0xFFFF6B9D);
  
  // Basic colors
  static const Color blackColor = Color(0xFF181725);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor = Color(0xFF7C7C7C);
  static const Color greyColor1 = Color(0xFFF2F3F2);
  static const Color greyColor2 = Color(0xFFE2E2E2);
  
  // Status colors
  static const Color goldColor = Color(0xFFFFC107);
  static const Color redColor = Color(0xFFFF647C);
  static const Color greenColor = Color(0xFF00C48C);
  static const Color blueColor = Color(0xFF0084F4);
  static const Color blueColor1 = Color(0xFF6979F8);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF53B175), Color(0xFF47F266)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFF8FFF9), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

