import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class L10n {
  static const supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
    Locale('bn'),
    Locale('kn'),
    Locale('te'),
    Locale('ta'),
    Locale('pa'),
    Locale('gu'),
  ];
}

final localeProvider = StateProvider<Locale?>((_) => const Locale('en'));
