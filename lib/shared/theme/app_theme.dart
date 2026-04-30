import 'package:flutter/material.dart';

class AppTheme {
  static const kBlue = Color(0xFF1565C0);
  static const kBlueLight = Color(0xFF1E88E5);
  static const kBlueDark = Color(0xFF0D47A1);
  static const kWhite = Color(0xFFFFFFFF);
  static const kGrey = Color(0xFF90A4AE);
  static const kBg = Color(0xFFF0F4FF);
  static const kError = Color(0xFFE53935);

  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kBlue),
    useMaterial3: true,
    scaffoldBackgroundColor: kBg,
  );

  static BoxDecoration get gradientDecoration => const BoxDecoration(
    gradient: LinearGradient(
      colors: [kBlueDark, kBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: kWhite,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(color: kBlue.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8)),
    ],
  );
}
