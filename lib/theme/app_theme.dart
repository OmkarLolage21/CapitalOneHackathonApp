import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF3F51B5); // Indigo
  static const Color accentColor = Color(0xFF4CAF50); // Green
  static const Color secondaryColor = Color(0xFF039BE5); // Light Blue

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color primaryText = Color(0xFF212121);
  static const Color secondaryText = Color(0xFF757575);

  // Custom Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF3949AB),
    Color(0xFF5C6BC0),
  ];

  static const List<Color> successGradient = [
    Color(0xFF43A047),
    Color(0xFF66BB6A),
  ];

  static const List<Color> infoGradient = [
    Color(0xFF039BE5),
    Color(0xFF29B6F6),
  ];

  static ThemeData _base(Brightness b) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      brightness: b,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final textTheme = GoogleFonts.interTextTheme(baseTheme.textTheme);

    return baseTheme.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor:
          b == Brightness.light ? scaffoldBackground : const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor:
            b == Brightness.light ? Colors.white : const Color(0xFF1E1E1E),
        centerTitle: false,
        iconTheme: IconThemeData(
          color: b == Brightness.light ? primaryText : Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: b == Brightness.light ? cardBackground : const Color(0xFF2C2C2C),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withOpacity(0.1),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            b == Brightness.light ? Colors.white : const Color(0xFF1E1E1E),
        selectedItemColor: primaryColor,
        unselectedItemColor:
            b == Brightness.light ? secondaryText : Colors.grey,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: b == Brightness.light
            ? Colors.grey.shade50
            : const Color(0xFF2A2A2A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: b == Brightness.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  // Helper methods for common UI elements
  static BoxDecoration cardBoxDecoration({
    Color? color,
    List<Color>? gradientColors,
    double borderRadius = 16.0,
    double shadowOpacity = 0.1,
    double shadowBlurRadius = 10,
    Offset shadowOffset = const Offset(0, 4),
  }) {
    return BoxDecoration(
      color: color ?? cardBackground,
      gradient: gradientColors != null
          ? LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(shadowOpacity),
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }
}
