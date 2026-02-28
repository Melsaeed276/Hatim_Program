import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/app.dart';
import 'package:hatim_program/features/auth/data/in_memory_auth_repository.dart';

void main() {
  testWidgets('app boots to login page', (WidgetTester tester) async {
    await tester.pumpWidget(
      HatimProgramApp(authRepository: InMemoryAuthRepository()),
    );
    await tester.pump();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
