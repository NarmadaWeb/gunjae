import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF13ec5b);
  static const Color primaryDark = Color(0xFF0ea842);
  static const Color backgroundLight = Color(0xFFf6f8f6);
  static const Color surfaceLight = Color(0xFFffffff);
  static const Color textMain = Color(0xFF0d1b12);
  static const Color textMuted = Color(0xFF4c9a66);
  static const Color borderGreen = Color(0xFFcfe7d7);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryDark,
        surface: surfaceLight,
        background: backgroundLight,
        onPrimary: textMain,
        onSurface: textMain,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.notoSans(
          color: textMain,
        ),
        bodyMedium: GoogleFonts.notoSans(
          color: textMain,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textMain,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.notoSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
