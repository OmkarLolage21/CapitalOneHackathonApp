import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const seed = Color(0xFF2D6A4F);
  static const accent = Color(0xFFFFB703);

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: scheme.surface,
    );

    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
      titleLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 22),
      titleMedium: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 18),
      labelLarge: GoogleFonts.manrope(fontWeight: FontWeight.w700),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: textTheme.labelLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: scheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        indicatorColor: scheme.primary.withOpacity(0.10),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: active ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: active ? FontWeight.w700 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final active = states.contains(WidgetState.selected);
          return IconThemeData(color: active ? scheme.primary : scheme.onSurfaceVariant);
        }),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
    );
  }

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: scheme.surface,
    );

    final textTheme = GoogleFonts.manropeTextTheme(base.textTheme);

    return lightTheme.copyWith(
      colorScheme: scheme,
      textTheme: textTheme,
      cardTheme: lightTheme.cardTheme.copyWith(color: scheme.surfaceContainerHigh),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(fillColor: scheme.surfaceContainerHighest),
      navigationBarTheme: lightTheme.navigationBarTheme.copyWith(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withOpacity(0.15),
      ),
    );
  }
}