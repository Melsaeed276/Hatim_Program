import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/service/user_services.dart';

void main() {
  group('UserServices', () {
    late UserServices userServices;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      userServices = UserServices();
      userServices.userDb = fakeFirestore.collection('users');
    });

    test('getUsersByIds returns users', () async {
      final user1 = UserModel(
        name: 'Test User 1',
        phoneNumber: '1234567890',
      );
      final user2 = UserModel(
        name: 'Test User 2',
        phoneNumber: '0987654321',
      );
      await userServices.addUser(user1);
      await userServices.addUser(user2);

      final result = await userServices.getUsersByIds([user1.id, user2.id]);

      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result[0].name, 'Test User 1');
      expect(result[1].name, 'Test User 2');
    });

    test('addUserToCommunity adds a community to a user', () async {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '1234567890',
      );
      await userServices.addUser(user);

      await userServices.addUserToCommunity(user.id, 'community1');

      final snapshot = await fakeFirestore.collection('users').doc(user.id).get();
      expect(snapshot.data()!['communityIds'], contains('community1'));
    });

    test('removeUserFromCommunity removes a community from a user', () async {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '1234567890',
        communityIds: ['community1'],
      );
      await userServices.addUser(user);

      await userServices.removeUserFromCommunity(user.id, 'community1');

      final snapshot = await fakeFirestore.collection('users').doc(user.id).get();
      expect(snapshot.data()!['communityIds'], isNot(contains('community1')));
    });
  });
}
