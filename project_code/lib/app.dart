import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'controller/contollers.dart';
import 'page_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final themeMode = context.select<UserController, ThemeMode>(
      (c) => c.getThemeMode,
    );
    final userId = context.select<UserController, String>(
      (c) => c.getCurrentUserID,
    );
    // Use select instead of watch to only rebuild when language actually changes
    final currentLanguage = context.select<LocalizationController, String>(
      (c) => c.getAppLang,
    );

    return MaterialApp.router(
      title: context.read<LocalizationController>().getLanguage().appTitle!,
      locale: Locale(currentLanguage),
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('tr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Return the saved locale
        return Locale(currentLanguage);
      },
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeController.getAppColor(),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeController.getAppColor(),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      routerConfig: AppRoutes.router(userId),
      // initialRoute: context.read<UserController>().getCurrentUserID != '0'
      //     ? AppRoutes.home
      //     :  AppRoutes.login,
    );
  }
}
