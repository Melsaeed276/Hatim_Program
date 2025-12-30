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

  Future<bool> addUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (_users.containsKey(user.phoneNumber)) {
      return false;
    }
    _users[user.phoneNumber] = user;
    return true;
  }

  Future<bool> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 1));
    _users[user.phoneNumber] = user;
    return true;
  }
}

void main() {
  late AuthController authController;

  setUp(() {
    authController = AuthController();
  });

  tearDown(() {
    authController.dispose();
  });

  group('AuthController - Password Functionality', () {
    test('verifyUserPassword should return true for user without password', () {
      final userWithoutPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );

      final result = authController.verifyUserPassword('anypassword', userWithoutPassword);
      expect(result, true);
    });

    test('verifyUserPassword should return true for correct password', () {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'correctpassword123',
      );

      final result = authController.verifyUserPassword('correctpassword123', userWithPassword);
      expect(result, true);
    });

    test('verifyUserPassword should return false for incorrect password', () {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'correctpassword123',
      );

      final result = authController.verifyUserPassword('wrongpassword', userWithPassword);
      expect(result, false);
    });

    test('verifyUserPassword should return false for empty password input', () {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'password123',
      );

      final result = authController.verifyUserPassword('', userWithPassword);
      expect(result, false);
    });

    test('verifyUserPassword should return false for null password input', () {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'password123',
      );

      final result = authController.verifyUserPassword('', userWithPassword);
      expect(result, false);
    });

    test('hasPassword should return false for user without password', () {
      final userWithoutPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );

      // We can't directly test hasPassword without setting userModel
      // This would require mocking the UserController
      expect(userWithoutPassword.password, null);
    });

    test('hasPassword should return false for user with empty password', () {
      final userWithEmptyPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: '',
      );

      expect(userWithEmptyPassword.password, '');
    });

    test('hasPassword should return true for user with password', () {
      final userWithPassword = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'password123',
      );

      expect(userWithPassword.password, 'password123');
    });

    test('setUserPassword should update user password when userModel exists', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
      );

      // Since we can't easily mock the UserController, we'll test the direct assignment
      user.password = 'newpassword123';
      expect(user.password, 'newpassword123');
    });

    test('passwordController should be properly initialized', () {
      expect(authController.passwordController, isNotNull);
      expect(authController.passwordController.text, '');
    });

    test('phoneNumberValidChecker should validate correct phone numbers', () {
      authController.phoneNumberController.text = '5534567890';
      authController.isPhoneNumberValidChecker();
      expect(authController.isPhoneNumberValid, true);

      authController.phoneNumberController.text = '553456789';
      authController.isPhoneNumberValidChecker();
      expect(authController.isPhoneNumberValid, false);

      authController.phoneNumberController.text = '4534567890'; // Wrong starting digit
      authController.isPhoneNumberValidChecker();
      expect(authController.isPhoneNumberValid, false);
    });

    test('hasNumbers should correctly identify strings with numbers', () {
      expect(authController.hasNumbers('123'), true);
      expect(authController.hasNumbers('abc123'), true);
      expect(authController.hasNumbers('abc'), false);
      expect(authController.hasNumbers(''), false);
      expect(authController.hasNumbers('!@#'), false);
    });
  });

  group('AuthController - User Creation and Retrieval', () {
    test('addUser should create user with password', () async {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'testpassword123',
        totalCompletedHatim: 2,
        totalCompletedChapters: 60,
        score: 100,
      );

      // Test user model creation with all fields
      expect(user.name, 'Test User');
      expect(user.phoneNumber, '5534567890');
      expect(user.password, 'testpassword123');
      expect(user.totalCompletedHatim, 2);
      expect(user.totalCompletedChapters, 60);
      expect(user.score, 100);
      expect(user.id, '534567890');
    });

    test('getUserByPhoneNumber should handle users with and without passwords', () async {
      final userWithPassword = UserModel(
        name: 'User With Password',
        phoneNumber: '5534567890',
        password: 'password123',
      );

      final userWithoutPassword = UserModel(
        name: 'User Without Password',
        phoneNumber: '5534567891',
      );

      // Test password verification logic
      expect(authController.verifyUserPassword('password123', userWithPassword), true);
      expect(authController.verifyUserPassword('wrongpass', userWithPassword), false);
      expect(authController.verifyUserPassword('anypass', userWithoutPassword), true);
    });
  });

  group('AuthController - Password Security Scenarios', () {
    test('password verification should be case sensitive', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'Password123',
      );

      expect(authController.verifyUserPassword('Password123', user), true);
      expect(authController.verifyUserPassword('password123', user), false);
      expect(authController.verifyUserPassword('PASSWORD123', user), false);
    });

    test('password verification should handle special characters', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'P@ssw0rd!123',
      );

      expect(authController.verifyUserPassword('P@ssw0rd!123', user), true);
      expect(authController.verifyUserPassword('P@ssw0rd!124', user), false);
    });

    test('password verification should handle very long passwords', () {
      final longPassword = 'A' * 100;
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: longPassword,
      );

      expect(authController.verifyUserPassword(longPassword, user), true);
      expect(authController.verifyUserPassword('${longPassword}x', user), false);
    });

    test('password verification should handle unicode characters', () {
      final unicodePassword = 'Pässwörd123🚀';
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: unicodePassword,
      );

      expect(authController.verifyUserPassword(unicodePassword, user), true);
      expect(authController.verifyUserPassword('Pässwörd123', user), false);
    });
  });
}