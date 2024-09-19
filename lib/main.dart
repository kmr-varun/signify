import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signify_isl/l10n/l10n.dart';
import 'package:signify_isl/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'local_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(), // Provide LocaleProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'ISL Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: localeProvider.locale, // Use the locale from LocaleProvider
      home: SplashScreen(),
    );
  }
}
