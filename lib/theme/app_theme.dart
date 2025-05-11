import 'package:flutter/material.dart';

class AppTheme {
  // Main colors
  static const Color primaryColor = Color(0xFF3551B5); // Deep indigo blue
  static const Color secondaryColor = Color(0xFF5773FF); // Lighter accent blue
  static const Color accentColor = Color(0xFF00C4B4); // Teal accent
  static const Color backgroundColor = Color(
    0xFFF8F9FC,
  ); // Light grey background
  static const Color cardColor = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF1E2C50); // Dark blue text
  static const Color textSecondary = Color(0xFF6E7A92); // Medium grey text

  // Status colors
  static const Color success = Color(0xFF26A69A); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color info = Color(0xFF2196F3); // Blue

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: backgroundColor,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        toolbarHeight: 70,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardColor,
        elevation: 1,
        shadowColor: Colors.black.withAlpha(26),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(color: textSecondary),
        titleLarge: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: primaryColor),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary:
            primaryColor, // Keep primary for consistency or choose a darker variant
        secondary:
            secondaryColor, // Keep secondary for consistency or choose a darker variant
        tertiary:
            accentColor, // Keep accent for consistency or choose a darker variant
        surface: const Color(0xFF121212), // Dark background
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white70, // Light text on dark background
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F1F1F), // Darker app bar
        toolbarHeight: 70,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E1E1E), // Dark card color
        elevation: 1,
        shadowColor: Colors.black.withAlpha(50),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              secondaryColor, // Use a lighter color for buttons in dark mode
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        labelLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(
            color: accentColor), // Use accent for headlines in dark mode
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.white24,
    );
  }
}

// Simple ThemeNotifier
class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  ThemeNotifier(this._themeData);

  ThemeData getTheme() => _themeData;

  bool isDarkMode() => _themeData.brightness == Brightness.dark;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (isDarkMode()) {
      _themeData = AppTheme.lightTheme;
    } else {
      _themeData = AppTheme.darkTheme;
    }
    notifyListeners();
  }
}
