import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF8FAFC);
  static const Color secondary = Color(0xFF1E293B);
  static const Color buttonSecondary = Color(0xFF2563EB);
  static const Color positive = Color(0xFF10B981);
  static const Color negative = Color(0xFFCA3D3D);
}

class TextStyles {
  static const TextStyle bodyText = TextStyle(
    fontSize: 25,
    color: AppColors.secondary,
    fontWeight: FontWeight.bold,
    fontFamily: "Inter",
  );
  static const TextStyle bodyButton = TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: "Inter",
  );
  static const TextStyle titleStyle = TextStyle(
    fontSize: 100,
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontFamily: "Inter",
  );
}
