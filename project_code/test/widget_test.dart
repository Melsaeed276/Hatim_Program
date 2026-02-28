import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';

void main() {
  testWidgets('app boots to design preview page', (WidgetTester tester) async {
    await tester.pumpWidget(const HatimProgramApp());
    await tester.pump();

    expect(find.text('Design System Preview'), findsOneWidget);
    expect(find.text('Issue #8 UI Foundation'), findsOneWidget);
  });
}
