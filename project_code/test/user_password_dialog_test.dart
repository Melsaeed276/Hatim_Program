import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hatim_program/page/dialogs/user_password_dialog.dart';

// Mock classes for testing
class MockAuthController extends AuthController {
  String? lastSetPassword;
  bool shouldSetPasswordSucceed = true;

  @override
  Future<bool> setUserPassword(String newPassword) async {
    if (shouldSetPasswordSucceed) {
      lastSetPassword = newPassword;
      return true;
    }
    return false;
  }
}

void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
  });

  Widget createPasswordDialog({
    String? storedPassword,
    bool isForVerification = true,
    String title = 'Test Title',
    String description = 'Test Description',
  }) {
    return ChangeNotifierProvider<AuthController>.value(
      value: mockAuthController,
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => UserPasswordDialog(
                    storedPassword: storedPassword,
                    isForVerification: isForVerification,
                    title: title,
                    description: description,
                  ),
                ),
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('UserPasswordDialog - Verification Mode', () {
    testWidgets('should display verification dialog elements', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        storedPassword: 'testpass123',
        isForVerification: true,
        title: 'Verify Password',
        description: 'Please enter your password',
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Verify Password'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('should accept correct password', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        storedPassword: 'correctpass123',
        isForVerification: true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'correctpass123');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Dialog should close (success)
      expect(find.text('Verify Password'), findsNothing);
    });

    testWidgets('should reject incorrect password', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        storedPassword: 'correctpass123',
        isForVerification: true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'wrongpass');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Dialog should still be open and show error
      expect(find.text('Verify Password'), findsOneWidget);
      expect(find.text('Incorrect password'), findsOneWidget);
    });

    testWidgets('should show validation error for empty password', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        storedPassword: 'testpass',
        isForVerification: true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });

  group('UserPasswordDialog - Creation Mode', () {
    testWidgets('should display creation dialog elements', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
        title: 'Set Password',
        description: 'Create a new password',
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Set Password'), findsOneWidget);
      expect(find.text('Create a new password'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Save Password'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '12345'); // Too short
      await tester.enterText(find.byType(TextFormField).at(1), '12345');
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should validate password confirmation match', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'password123');
      await tester.enterText(find.byType(TextFormField).at(1), 'password124'); // Different
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should successfully create password', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'newpassword123');
      await tester.enterText(find.byType(TextFormField).at(1), 'newpassword123');
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      // Dialog should close and password should be set
      expect(find.text('Set Password'), findsNothing);
      expect(mockAuthController.lastSetPassword, 'newpassword123');
    });

    testWidgets('should show support contact note', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('contact support at +095388902129'), findsOneWidget);
    });
  });

  group('UserPasswordDialog - Password Visibility Toggle', () {
    testWidgets('should toggle password visibility in verification mode', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: true,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Initially password should be obscured - check by finding visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Tap visibility toggle
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Password should now be visible - visibility_off icon should appear
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Back to obscured state
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
    });

    testWidgets('should toggle password visibility in creation mode', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Initially both passwords should be obscured - check visibility icons
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      // Toggle first field visibility
      await tester.tap(find.byIcon(Icons.visibility).at(0));
      await tester.pumpAndSettle();

      // First field should be visible, second still obscured
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Toggle second field visibility
      await tester.tap(find.byIcon(Icons.visibility).at(0)); // Second visibility icon
      await tester.pumpAndSettle();

      // Both fields should be visible
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
      expect(find.byIcon(Icons.visibility), findsNothing);
    });
  });

  group('UserPasswordDialog - Error Handling', () {
    testWidgets('should handle password setting failure', (WidgetTester tester) async {
      mockAuthController.shouldSetPasswordSucceed = false;

      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'password123');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(find.text('Failed to set password'), findsOneWidget);
    });

    testWidgets('should handle close button tap', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog());

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Test Title'), findsNothing);
    });
  });

  group('UserPasswordDialog - Loading States', () {
    testWidgets('should show loading indicator during password operations', (WidgetTester tester) async {
      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'password123');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');

      await tester.tap(find.text('Save Password'));
      await tester.pump(); // Don't settle to catch loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save Password'), findsNothing); // Button should be replaced by loading
    });
  });

  group('UserPasswordDialog - Edge Cases', () {
    testWidgets('should handle very long passwords', (WidgetTester tester) async {
      final longPassword = 'A' * 100;

      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), longPassword);
      await tester.enterText(find.byType(TextFormField).at(1), longPassword);
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(mockAuthController.lastSetPassword, longPassword);
    });

    testWidgets('should handle passwords with special characters', (WidgetTester tester) async {
      final specialPassword = 'P@ssw0rd!#\$%^&*()';

      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), specialPassword);
      await tester.enterText(find.byType(TextFormField).at(1), specialPassword);
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(mockAuthController.lastSetPassword, specialPassword);
    });

    testWidgets('should handle unicode characters in passwords', (WidgetTester tester) async {
      final unicodePassword = 'Pässwörd123🚀🌟';

      await tester.pumpWidget(createPasswordDialog(
        isForVerification: false,
      ));

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), unicodePassword);
      await tester.enterText(find.byType(TextFormField).at(1), unicodePassword);
      await tester.tap(find.text('Save Password'));
      await tester.pumpAndSettle();

      expect(mockAuthController.lastSetPassword, unicodePassword);
    });
  });
}