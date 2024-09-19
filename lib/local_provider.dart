import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default locale

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (![
      'en',
      'hi',
    ].contains(locale.languageCode)) return;

    _locale = locale;
    notifyListeners();
  }
}
