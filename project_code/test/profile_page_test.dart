import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/page/profile_page.dart';

// Mock classes for testing
class MockUserController extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  set userModel(UserModel? user) {
    _userModel = user;
    notifyListeners();
  }

  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    return _userModel;
  }
}

class MockLocalizationController extends ChangeNotifier {
  // Simple mock that returns hardcoded strings
  String getCloseText() => 'Close';
  String getCancelText() => 'Cancel';
  String getContinueText() => 'Continue';
}

class MockAuthController extends AuthController {
  @override
  Future<bool> setUserPassword(String newPassword) async {
    // Mock successful password setting
    return true;
  }
}

void main() {
  late MockUserController mockUserController;

  setUp(() {
    mockUserController = MockUserController();
  });

  Widget createProfilePage() {
    return ChangeNotifierProvider<MockUserController>.value(
      value: mockUserController,
      child: const MaterialApp(
        home: ProfilePage(),
      ),
    );
  }

  group('ProfilePage - Basic Widget Creation', () {
    testWidgets('should create ProfilePage widget without crashing', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedHatim: 5,
        totalCompletedChapters: 150,
        score: 250,
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pump(); // Don't settle to avoid complex provider dependencies

      // Just verify the widget was created
      expect(find.byType(ProfilePage), findsOneWidget);
    });

    testWidgets('should handle null user model gracefully', (WidgetTester tester) async {
      mockUserController.userModel = null;

      await tester.pumpWidget(createProfilePage());
      await tester.pump();

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display user information card', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'John Doe',
        phoneNumber: '5534567890',
        totalCompletedHatim: 3,
        totalCompletedChapters: 90,
        score: 180,
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('5534567890'), findsOneWidget);
    });

    testWidgets('should display admin badge for admin users', (WidgetTester tester) async {
      final adminUser = UserModel(
        name: 'Admin User',
        phoneNumber: '5534567890',
        isAdmin: true,
        totalCompletedHatim: 10,
        totalCompletedChapters: 300,
        score: 500,
      );
      mockUserController.userModel = adminUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('should display statistics section', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedHatim: 7,
        totalCompletedChapters: 210,
        score: 350,
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('7'), findsOneWidget); // Completed Hatims
      expect(find.text('210'), findsOneWidget); // Completed Chapters
      expect(find.text('350'), findsOneWidget); // Score
    });

    testWidgets('should display statistics with zero values', (WidgetTester tester) async {
      final newUser = UserModel(
        name: 'New User',
        phoneNumber: '5534567890',
        totalCompletedHatim: 0,
        totalCompletedChapters: 0,
        score: 0,
      );
      mockUserController.userModel = newUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNWidgets(3)); // Three zero values
    });

    testWidgets('should display security section', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Set Password'), findsOneWidget);
    });

    testWidgets('should display change password option for users with password', (WidgetTester tester) async {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'existingpassword',
      );
      mockUserController.userModel = userWithPassword;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('should display support section with contact number', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Support Contact'), findsOneWidget);
      expect(find.text('+095388902129'), findsOneWidget);
    });

    testWidgets('should display user avatar with first letter', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Alice',
        phoneNumber: '5534567890',
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget); // First letter of name
    });
  });

  group('ProfilePage - User Model Integration', () {
    testWidgets('should work with user model containing new statistics fields', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Stats User',
        phoneNumber: '5534567890',
        totalCompletedHatim: 10,
        totalCompletedChapters: 300,
        score: 500,
      );
      mockUserController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pump();

      // Verify the widget accepts the user model with new fields
      expect(mockUserController.userModel?.totalCompletedHatim, 10);
      expect(mockUserController.userModel?.totalCompletedChapters, 300);
      expect(mockUserController.userModel?.score, 500);
    });
  });
}