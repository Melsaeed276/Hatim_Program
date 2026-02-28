@Tags(['design'])
library;

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';

void main() {
  testWidgets('compact layout label is shown at mobile width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const HatimProgramApp());
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

    await tester.pumpWidget(const HatimProgramApp());
    await tester.pump();

    expect(find.textContaining('Current layout class: Medium'), findsOneWidget);
  });
}
