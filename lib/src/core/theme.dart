import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

ThemeData buildLightTheme(BuildContext context) {
  final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32));
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardTheme: const CardTheme(clipBehavior: Clip.antiAlias, elevation: 0),
    appBarTheme: const AppBarTheme(centerTitle: true),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
    ),
  );
}

ThemeData buildDarkTheme(BuildContext context) {
  final base = buildLightTheme(context);
  return base.copyWith(colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2E7D32),
    brightness: Brightness.dark,
  ));
}

final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.system);