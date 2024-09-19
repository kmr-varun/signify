import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

import 'local_provider.dart';


class LanguageToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return ElevatedButton(
      onPressed: () {
        if (currentLocale == const Locale('en')) {
          localeProvider.setLocale(const Locale('hi'));
        } else {
          localeProvider.setLocale(const Locale('en'));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        minimumSize: const Size(20.0, 20.0),
      ),
      child: Text(
        AppLocalizations.of(context)!.toggleLanguage,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
