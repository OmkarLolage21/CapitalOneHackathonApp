// Basic localization support for new structure compatibility
import 'package:flutter/material.dart';

class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Dashboard strings
  String greeting(String name) => 'Hello, $name!';
  String get advisoriesToday => "Today's Advisories";
  String get quickAsk => 'Ask a Question';
  String get marketPrices => 'Market Prices';
  String get todayWeather => "Today's Weather";
  String get schemesLoans => 'Schemes & Loans';
  String get why => 'Why?';
  String get moreDetails => 'More Details';
  String get translateToEnglish => 'Translate to English';

  // Navigation
  String get chat => 'Chat';
  String get weather => 'Weather';
  String get market => 'Market';
  String get alerts => 'Alerts';

  // Chat strings
  String get typeMessage => 'Type a message...';
  String get attachImage => 'Attach Image';
  String get speak => 'Speak';
  String get stop => 'Stop';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations();

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}