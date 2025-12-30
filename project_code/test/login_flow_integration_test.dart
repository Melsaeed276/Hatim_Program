import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hatim_program/models/user_model.dart';

// Mock UserRepo for testing
class MockUserRepo {
  final Map<String, UserModel> _users = {};

  Future<UserModel?> getUserByPhoneNumber(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 1));
    return _users[phoneNumber];
  }

  Future<bool> isUserExist(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 1));
    return _users.containsKey(phoneNumber);
  }

  void addUserForTesting(UserModel user) {
    _users[user.phoneNumber] = user;
  }
}

// Simple test that validates the core logic without complex providers
class TestAuthController extends AuthController {
  UserModel? testUser;

  @override
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    return testUser;
  }
}

void main() {
  late TestAuthController testAuthController;

  setUp(() {
    testAuthController = TestAuthController();
  });

  group('Login Flow Integration - Password Verification Logic', () {
    test('should allow login for user without password', () async {
      // Create a user without password
      final userWithoutPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedHatim: 2,
        totalCompletedChapters: 60,
        score: 100,
      );

      final result = testAuthController.verifyUserPassword(
        'anypassword',
        userWithoutPassword,
      );
      expect(result, true);
    });

    test('should verify correct password for user with password', () async {
      // Create a user with password
      final userWithPassword = UserModel(
        name: 'Secure User',
        phoneNumber: '5534567890',
        password: 'securepass123',
        totalCompletedHatim: 5,
        totalCompletedChapters: 150,
        score: 250,
      );

      final result = testAuthController.verifyUserPassword(
        'securepass123',
        userWithPassword,
      );
      expect(result, true);
    });

    test('should reject incorrect password for user with password', () async {
      final userWithPassword = UserModel(
        name: 'Secure User',
        phoneNumber: '5534567890',
        password: 'securepass123',
      );

      final result = testAuthController.verifyUserPassword(
        'wrongpass',
        userWithPassword,
      );
      expect(result, false);
    });

    test('should handle empty password input for verification', () async {
      final userWithPassword = UserModel(
        name: 'Secure User',
        phoneNumber: '5534567890',
        password: 'somepass123',
      );

      final result = testAuthController.verifyUserPassword(
        '',
        userWithPassword,
      );
      expect(result, false);
    });

    test(
      'should handle admin user with both admin and user passwords',
      () async {
        final adminUser = UserModel(
          name: 'Admin User',
          phoneNumber: '5534567890',
          isAdmin: true,
          adminPassword: 'adminpass123',
          password: 'userpass123',
          totalCompletedHatim: 10,
          totalCompletedChapters: 300,
          score: 500,
        );

        // User password verification should work independently
        final userPasswordResult = testAuthController.verifyUserPassword(
          'userpass123',
          adminUser,
        );
        expect(userPasswordResult, true);

        final wrongUserPasswordResult = testAuthController.verifyUserPassword(
          'wrongpass',
          adminUser,
        );
        expect(wrongUserPasswordResult, false);
      },
    );

    test('should validate phone number format correctly', () async {
      testAuthController.phoneNumberController.text = '5534567890';
      testAuthController.isPhoneNumberValidChecker();
      expect(testAuthController.isPhoneNumberValid, true);

      testAuthController.phoneNumberController.text =
          '4534567890'; // Wrong starting digit
      testAuthController.isPhoneNumberValidChecker();
      expect(testAuthController.isPhoneNumberValid, false);

      testAuthController.phoneNumberController.text = '553456789'; // Too short
      testAuthController.isPhoneNumberValidChecker();
      expect(testAuthController.isPhoneNumberValid, false);
    });

    test('should handle password with special characters', () async {
      final userWithComplexPassword = UserModel(
        name: 'Complex User',
        phoneNumber: '5534567890',
        password: 'P@ssw0rd!123#\$%',
      );

      final result = testAuthController.verifyUserPassword(
        'P@ssw0rd!123#\$%',
        userWithComplexPassword,
      );
      expect(result, true);
    });

    test('should handle very long passwords', () async {
      final longPassword = 'A' * 50;
      final userWithLongPassword = UserModel(
        name: 'Long Pass User',
        phoneNumber: '5534567890',
        password: longPassword,
      );

      final result = testAuthController.verifyUserPassword(
        longPassword,
        userWithLongPassword,
      );
      expect(result, true);

      final wrongResult = testAuthController.verifyUserPassword(
        '${longPassword}x',
        userWithLongPassword,
      );
      expect(wrongResult, false);
    });

    test('should handle case sensitive passwords', () async {
      final user = UserModel(
        name: 'Case Sensitive User',
        phoneNumber: '5534567890',
        password: 'Password123',
      );

      expect(testAuthController.verifyUserPassword('Password123', user), true);
      expect(testAuthController.verifyUserPassword('password123', user), false);
      expect(testAuthController.verifyUserPassword('PASSWORD123', user), false);
    });
  });
}
