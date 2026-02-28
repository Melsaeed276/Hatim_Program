@Tags(['design', 'golden'])
library;

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';

void main() {
  testWidgets('design preview screen matches mobile golden', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const HatimProgramApp());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(HatimProgramApp),
      matchesGoldenFile('../goldens/design_preview_mobile.png'),
    );
  });
}
