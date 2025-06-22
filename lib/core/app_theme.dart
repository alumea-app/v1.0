import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Prevent instantiation of this class
  AppTheme._();

  // Define our core colors
  static const Color primaryBlue = Color(0xFF6B728E);
  static const Color secondaryLavender = Color(0xFFA78BFA);
  static const Color lightGrayBackground = Color(0xFFF9FAFB);
  static const Color darkerGraySurface = Color(0xFFE5E7EB);
  static const Color accentGreen = Color(0xFF6EE7B7);
  static const Color accentCoral = Color(0xFFFCA5A5);
  static const Color textPrimary = Color(0xFF374151);
  static const Color textSecondary = Color(0xFF6B7280);

  // This is our master light theme.
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightGrayBackground,
    primaryColor: primaryBlue,

    // Use GoogleFonts to apply Nunito to our text theme
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      displayColor: textPrimary, // For headlines
      bodyColor: textPrimary,    // For normal body text
    ),
    
    // Modern theming using ColorScheme
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: secondaryLavender,
      background: lightGrayBackground,
      surface: Colors.white, // For things like Cards
      error: accentCoral,    // Our SOS button color works as a gentle error color
      onPrimary: Colors.white, // Text/icon color on a primary-colored background
      onSecondary: Colors.white,
      onBackground: textPrimary,
      onSurface: textPrimary,
      onError: Colors.white,
    ),

    // Define specific component themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, 
        backgroundColor: primaryBlue, // Text color for ElevatedButtons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
  );

  // TODO: We can define a darkTheme here later if we want.
  // static final ThemeData darkTheme = ThemeData(...);
}