import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'src/core/app_router.dart';
import 'src/core/di.dart';
import 'src/core/theme.dart';
import 'src/core/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDI.init();
  runApp(const ProviderScope(child: AgriApp()));
}

class AgriApp extends ConsumerWidget {
  const AgriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Agri Advisor',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(context),
      darkTheme: buildDarkTheme(context),
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}