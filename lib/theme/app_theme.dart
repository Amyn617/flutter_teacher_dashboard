import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Main colors
  static const Color primaryColor = Color(0xFF3551B5); // Deep indigo blue
  static const Color secondaryColor = Color(0xFF5773FF); // Lighter accent blue
  static const Color accentColor = Color(0xFF00C4B4); // Teal accent
  static const Color backgroundColor =
      Color(0xFFF8F9FC); // Light grey background
  static const Color cardColor = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF1E2C50); // Dark blue text
  static const Color textSecondary = Color(0xFF6E7A92); // Medium grey text

  // Neutral colors
  static const Color neutralLight = Color(0xFFE5E9F2);
  static const Color neutralMedium = Color(0xFFCDD5E4);
  static const Color neutralDark = Color(0xFF8492A6);

  // Status colors
  static const Color success = Color(0xFF26A69A); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color info = Color(0xFF2196F3); // Blue

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  static const Color darkAccentColor =
      Color(0xFF4ECDC4); // Brighter teal for dark mode

  // Dark theme text colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White
  static const Color darkTextSecondary = Color(0xFFE0E0E0); // Light grey
  static const Color darkTextTertiary = Color(0xFFB0B0B0); // Medium grey

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: backgroundColor,
        background: backgroundColor,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 2,
        shadowColor: primaryColor.withAlpha(50),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: textPrimary),
          displayMedium: TextStyle(color: textPrimary),
          displaySmall: TextStyle(color: textPrimary),
          headlineLarge: TextStyle(color: textPrimary),
          headlineMedium: TextStyle(color: textPrimary),
          headlineSmall:
              TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          titleLarge:
              TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
          titleMedium:
              TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: textPrimary),
          bodyLarge: TextStyle(color: textPrimary),
          bodyMedium: TextStyle(color: textSecondary),
          bodySmall: TextStyle(color: textSecondary),
          labelLarge: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor),
          labelMedium: TextStyle(color: textSecondary),
          labelSmall: TextStyle(color: textSecondary),
        ),
      ),
      iconTheme: const IconThemeData(color: textSecondary),
      dividerColor: neutralMedium,
      dialogBackgroundColor: Colors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: darkAccentColor,
        surface: darkSurface,
        background: darkBackground,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1A1A2E), // Darker blue app bar
        foregroundColor: Colors.white,
        toolbarHeight: 70,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(100),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: darkBackground,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkCardColor,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(77),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 3,
          shadowColor: secondaryColor.withAlpha(77),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          displayLarge: const TextStyle(color: darkTextPrimary),
          displayMedium: const TextStyle(color: darkTextPrimary),
          displaySmall: const TextStyle(color: darkTextPrimary),
          headlineLarge: const TextStyle(color: darkTextPrimary),
          headlineMedium: const TextStyle(color: darkTextPrimary),
          headlineSmall: const TextStyle(
              color: darkAccentColor, fontWeight: FontWeight.bold),
          titleLarge: const TextStyle(
              color: darkTextPrimary, fontWeight: FontWeight.w600),
          titleMedium: const TextStyle(
              color: darkTextPrimary, fontWeight: FontWeight.w500),
          titleSmall: const TextStyle(color: darkTextPrimary),
          bodyLarge: TextStyle(color: Colors.white.withAlpha(230)),
          bodyMedium: TextStyle(color: Colors.white.withAlpha(200)),
          bodySmall: TextStyle(color: Colors.white.withAlpha(180)),
          labelLarge: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: darkAccentColor),
          labelMedium: TextStyle(color: Colors.white.withAlpha(200)),
          labelSmall: TextStyle(color: Colors.white.withAlpha(180)),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white.withAlpha(217)),
      dividerColor: Colors.white.withAlpha(38),
      dialogBackgroundColor: darkCardColor,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: darkCardColor,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
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
