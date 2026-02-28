@Tags(['design'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';

void main() {
  testWidgets('interactive controls expose semantics labels', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    addTearDown(handle.dispose);

    await tester.pumpWidget(const HatimProgramApp());
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
    await tester.pumpWidget(const HatimProgramApp());
    await tester.pump();

    await tester.tap(find.byType(DropdownButtonFormField<Locale>));
    await tester.pump();
    await tester.tap(find.text('Arabic').last);
    await tester.pump();

    final Directionality directionality = tester.widget(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
