@Tags(['design'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';
import 'package:hatim_program/app/theme/app_theme.dart';
import 'package:hatim_program/features/design_preview/presentation/design_preview_page.dart';

void main() {
  Widget buildDesignPreview(Locale locale) {
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

  testWidgets('interactive controls expose semantics labels', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    addTearDown(handle.dispose);

    await tester.pumpWidget(buildDesignPreview(const Locale('en')));
    await tester.pump();

    expect(find.bySemanticsLabel('Primary action: Continue'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Secondary action: Sign in with Google'),
      findsOneWidget,
    );
  });

  testWidgets('Arabic locale applies RTL directionality', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildDesignPreview(const Locale('ar')));
    await tester.pump();
    await tester.pumpWidget(const HatimProgramApp());
    await tester.pump();

    await tester.tap(find.byType(DropdownButtonFormField<Locale>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Arabic').last);
    await tester.pumpAndSettle();

    final Directionality directionality = tester.widget(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
