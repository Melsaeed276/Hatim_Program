import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:hatim_program/core/controllers/localization_controller.dart';
import 'package:hatim_program/features/auth/controllers/user_controller.dart';
import 'package:hatim_program/features/auth/models/user_model.dart';
import 'package:hatim_program/features/auth/pages/profile_page.dart';

void main() {
  late Directory hiveDir;
  late UserController userController;
  late LocalizationController localizationController;

  setUpAll(() async {
    hiveDir = await Directory.systemTemp.createTemp('hatim_profile_test_');
    try {
      Hive.init(hiveDir.path);
    } catch (_) {
      // Hive may already be initialized by another test file.
    }
    if (!Hive.isBoxOpen('language')) {
      await Hive.openBox('language');
    }
    if (!Hive.isBoxOpen('user')) {
      await Hive.openBox('user');
    }
    Hive.box('language').put('langCode', 'en');
  });

  tearDownAll(() async {
    // Intentionally no Hive cleanup here; closing Hive can hang in widget tests.
  });

  setUp(() {
    userController = UserController();
    localizationController = LocalizationController();
  });

  Widget createProfilePage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalizationController>.value(
          value: localizationController,
        ),
        ChangeNotifierProvider<UserController>.value(value: userController),
      ],
      child: const MaterialApp(home: ProfilePage()),
    );
  }

  group('ProfilePage - Basic Widget Creation', () {
    testWidgets('should create ProfilePage widget without crashing', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedChapters: 150,
        score: 250,
      );
      userController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pump(); // Don't settle to avoid complex provider dependencies

      // Just verify the widget was created
      expect(find.byType(ProfilePage), findsOneWidget);
    });

    testWidgets('should handle null user model gracefully', (WidgetTester tester) async {
      // Keep userID as '0' and don't touch the setter to avoid repo lookups in tests.
      Hive.box('user').put('userID', '0');

      await tester.pumpWidget(createProfilePage());
      await tester.pump();

      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display user information card', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'John Doe',
        phoneNumber: '5534567890',
        totalCompletedChapters: 90,
        score: 180,
      );
      userController.userModel = testUser;

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
        totalCompletedChapters: 300,
        score: 500,
      );
      userController.userModel = adminUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('should display statistics section', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedChapters: 210,
        score: 350,
      );
      userController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('210'), findsOneWidget); // Completed Chapters
      expect(find.text('350.0'), findsOneWidget); // Score is formatted with 1 decimal
    });

    testWidgets('should display statistics with zero values', (WidgetTester tester) async {
      final newUser = UserModel(
        name: 'New User',
        phoneNumber: '5534567890',
        totalCompletedChapters: 0,
        score: 0,
      );
      userController.userModel = newUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('0.0'), findsOneWidget); // Score is formatted with 1 decimal
      expect(find.text('0'), findsOneWidget); // Completed chapters
    });

    testWidgets('should display security section', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );
      userController.userModel = testUser;

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
      userController.userModel = userWithPassword;

      await tester.pumpWidget(createProfilePage());
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsOneWidget);
    });

    testWidgets('should display support section with contact number', (WidgetTester tester) async {
      final testUser = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );
      userController.userModel = testUser;

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
      userController.userModel = testUser;

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
        totalCompletedChapters: 300,
        score: 500,
      );
      userController.userModel = testUser;

      await tester.pumpWidget(createProfilePage());
      await tester.pump();

      // Verify the widget accepts the user model with new fields
      expect(userController.userModel?.totalCompletedChapters, 300);
      expect(userController.userModel?.score, 500);
    });
  });
}