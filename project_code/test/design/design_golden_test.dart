@Tags(['design', 'golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';
import 'package:hatim_program/app/theme/app_theme.dart';
import 'package:hatim_program/features/design_preview/presentation/design_preview_page.dart';

void main() {
  Widget buildDesignPreview() {
    const Locale locale = Locale('en');
    final ThemeData stableTheme = AppTheme.buildLightTheme(
      locale,
    ).copyWith(platform: TargetPlatform.android);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('ar'),
        Locale('tr'),
      ],
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: stableTheme,
      home: DesignPreviewPage(locale: locale, onLocaleChanged: (_) {}),
    );
  }

  testWidgets('design preview screen matches mobile golden', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildDesignPreview());
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../goldens/design_preview_mobile.png'),
    );
  });
}
