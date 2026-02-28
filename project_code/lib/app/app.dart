import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'navigation/app_routes.dart';
import 'theme/app_theme.dart';

class HatimProgramApp extends StatefulWidget {
  const HatimProgramApp({super.key});

  @override
  State<HatimProgramApp> createState() => _HatimProgramAppState();
}

class _HatimProgramAppState extends State<HatimProgramApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hatim Program',
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('tr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.buildLightTheme(_locale),
      onGenerateRoute: (settings) {
        return AppRoutes.onGenerateRoute(
          settings,
          locale: _locale,
          onLocaleChanged: _setLocale,
        );
      },
      initialRoute: AppRoutes.designPreview,
    );
  }
}
