import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/features/auth/models/user_model.dart';

void main() {
  group('UserModel - New Fields and Serialization', () {
    test(
      'UserModel constructor with new fields should initialize correctly',
      () {
        final user = UserModel(
          name: 'Test User',
          phoneNumber: '5534567890',
          isAdmin: false,
          adminPassword: null,
        password: 'testpass123',
        totalCompletedChapters: 150,
        score: 250,
        );

        expect(user.name, 'Test User');
        expect(user.phoneNumber, '5534567890');
        expect(user.id, '5534567890'); // Processed phone number
        expect(user.isAdmin, false);
        expect(user.adminPassword, null);
        expect(user.password, 'testpass123');
        expect(user.totalCompletedChapters, 150);
        expect(user.score, 250);
        expect(user.groups, isEmpty);
        expect(user.joinedByAdminId, null);
        expect(user.joinedAt, null);
      },
    );

    test(
      'UserModel constructor should use default values when not provided',
      () {
        final user = UserModel(name: 'Test User', phoneNumber: '5534567890');

        expect(user.password, null);
        expect(user.totalCompletedChapters, 0);
        expect(user.score, 0);
        expect(user.isAdmin, false);
        expect(user.adminPassword, null);
      },
    );

    test('UserModel.fromJson should correctly deserialize new fields', () {
      final json = {
        'id': '5534567890',
        'name': 'Test User',
        'phoneNumber': '5534567890',
        'isAdmin': true,
        'adminPassword': 'admin123',
        'password': 'userpass123',
        'totalCompletedChapters': 90,
        'score': 180,
        'groups': ['group1', 'group2'],
        'joinedByAdminId': 'admin_123',
        'joinedAt': '2023-10-27T10:00:00.000',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '5534567890');
      expect(user.name, 'Test User');
      expect(user.phoneNumber, '5534567890');
      expect(user.isAdmin, true);
      expect(user.adminPassword, 'admin123');
      expect(user.password, 'userpass123');
      expect(user.totalCompletedChapters, 90);
      expect(user.score, 180);
      expect(user.groups, ['group1', 'group2']);
      expect(user.joinedByAdminId, 'admin_123');
      expect(user.joinedAt?.year, 2023);
    });

    test(
      'UserModel.fromJson should use default values for missing new fields',
      () {
        final json = {
          'id': '534567890',
          'name': 'Test User',
          'phoneNumber': '5534567890',
          'isAdmin': false,
          'groups': <String>[],
        };

        final user = UserModel.fromJson(json);

        expect(user.password, null);
        expect(user.totalCompletedChapters, 0);
        expect(user.score, 0);
      },
    );

    test('UserModel.toJson should correctly serialize new fields', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: 'testpass123',
        totalCompletedChapters: 150,
        score: 250,
      );

      final json = user.toJson();

      expect(json['id'], '5534567890');
      expect(json['name'], 'Test User');
      expect(json['phoneNumber'], '5534567890');
      expect(json['password'], 'testpass123');
      expect(json['totalCompletedChapters'], 150);
      expect(json['score'], 250);
      expect(json['isAdmin'], false);
      expect(json['groups'], isEmpty);
      expect(json.containsKey('joinedByAdminId'), false);
    });

    test('UserModel.toJson should include referral fields when present', () {
      final joinedDate = DateTime.now();
      final user = UserModel(
        name: 'Referred User',
        phoneNumber: '5534567890',
        joinedByAdminId: 'admin_456',
        joinedAt: joinedDate,
      );

      final json = user.toJson();

      expect(json['joinedByAdminId'], 'admin_456');
      expect(json['joinedAt'], joinedDate.toIso8601String());
    });

    test('UserModel.toJson should not include null password', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        password: null,
      );

      final json = user.toJson();

      expect(json.containsKey('password'), false);
    });

    test('UserModel.toJson should include adminPassword when present', () {
      final user = UserModel(
        name: 'Admin User',
        phoneNumber: '5534567890',
        isAdmin: true,
        adminPassword: 'adminpass123',
        password: 'userpass123',
      );

      final json = user.toJson();

      expect(json['adminPassword'], 'adminpass123');
      expect(json['password'], 'userpass123');
    });

    test('UserModel statistics should support increment operations', () {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '5534567890',
        totalCompletedChapters: 60,
        score: 100,
      );

      // Simulate additional progress
      user.totalCompletedChapters += 30;
      user.score += 50;

      expect(user.totalCompletedChapters, 90);
      expect(user.score, 150);
    });
    test('UserModel phone number processing should handle various formats', () {
      // Test leading zero removal
      final user1 = UserModel(name: 'User1', phoneNumber: '05534567890');
      expect(user1.id, '5534567890');

      // Test spaces and dashes removal
      final user2 = UserModel(name: 'User2', phoneNumber: '5 534-567-890');
      expect(user2.id, '5534567890');

      // Test plus sign removal
      final user3 = UserModel(name: 'User3', phoneNumber: '+905534567890');
      expect(
        user3.id,
        '905534567890',
      ); // Reverted version doesn't strip 90 anymore
    });

    test('UserModel equality methods should work correctly', () {
      final user1 = UserModel(name: 'User', phoneNumber: '5534567890');

      expect(user1.isEqual('5534567890'), true);
      expect(user1.isEqual('5534567891'), false);

      // Test with processed phone numbers
      expect(user1.isEqual('5534567890'), true);
    });

    test('UserModel group methods should work correctly', () {
      final user = UserModel(name: 'Test User', phoneNumber: '5534567890');

      expect(user.hasGroup('group1'), false);
      expect(user.isInTheGroups('group1'), false);

      user.groups.add('group1');
      expect(user.hasGroup('group1'), true);
      expect(user.isInTheGroups('group1'), true);
      expect(user.isInTheGroups('group2'), false);
    });

    test('UserModel serialization roundtrip should preserve all data', () {
      final originalUser = UserModel(
        name: 'Complete Test User',
        phoneNumber: '5534567890',
        isAdmin: true,
        adminPassword: 'admin123',
        password: 'user123',
        totalCompletedChapters: 300,
        score: 500,
      );
      originalUser.groups.addAll(['group1', 'group2', 'group3']);

      // Serialize to JSON
      final json = originalUser.toJson();

      // Deserialize from JSON
      final deserializedUser = UserModel.fromJson(json);

      // Verify all fields match
      expect(deserializedUser.id, originalUser.id);
      expect(deserializedUser.name, originalUser.name);
      expect(deserializedUser.phoneNumber, originalUser.phoneNumber);
      expect(deserializedUser.isAdmin, originalUser.isAdmin);
      expect(deserializedUser.adminPassword, originalUser.adminPassword);
      expect(deserializedUser.password, originalUser.password);
      expect(
        deserializedUser.totalCompletedChapters,
        originalUser.totalCompletedChapters,
      );
      expect(deserializedUser.score, originalUser.score);
      expect(deserializedUser.groups, originalUser.groups);
    });
  });
}
