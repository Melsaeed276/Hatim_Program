@Tags(['design'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/theme/app_theme.dart';
import 'package:hatim_program/features/design_preview/presentation/design_preview_page.dart';

void main() {
  Widget buildDesignPreview() {
    const Locale locale = Locale('en');
    return MaterialApp(
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
      theme: AppTheme.buildLightTheme(locale),
      home: DesignPreviewPage(locale: locale, onLocaleChanged: (_) {}),
    );
  }

  testWidgets('compact layout label is shown at mobile width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildDesignPreview());
    await tester.pump();

    expect(
      find.textContaining('Current layout class: Compact'),
      findsOneWidget,
    );
  });

  testWidgets('medium layout label is shown at tablet width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(700, 1024));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildDesignPreview());
    await tester.pump();

    expect(find.textContaining('Current layout class: Medium'), findsOneWidget);
  });
}
