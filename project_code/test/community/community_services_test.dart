import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/user_model.dart';
import 'package:hatim_program/models/zikir_model.dart';
import 'package:hatim_program/service/community_services.dart';
import 'package:hatim_program/service/user_services.dart';

class MockUserServices extends Mock implements UserServices {}

void main() {
  group('CommunityServices', () {
    late CommunityServices communityServices;
    late FakeFirebaseFirestore fakeFirestore;
    late UserServices userServices;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      userServices = MockUserServices();
      communityServices = CommunityServices(userServices: userServices);
      communityServices.communityDb = fakeFirestore.collection('communities');
    });

    test('createCommunity creates a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );

      await communityServices.createCommunity(community);

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.exists, isTrue);
      expect(snapshot.data()!['name'], 'Test Community');
    });

    test('getCommunityById returns a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      final result = await communityServices.getCommunityById('1');

      expect(result, isNotNull);
      expect(result!.name, 'Test Community');
    });

    test('getCommunitiesForUser returns communities', () async {
      final user = UserModel(
        name: 'Test User',
        phoneNumber: '1234567890',
        communityIds: ['1'],
      );
      when(userServices.getUserByPhoneNumber('user1'))
          .thenAnswer((_) async => user);

      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      final result = await communityServices.getCommunitiesForUser('user1');

      expect(result, isNotEmpty);
      expect(result[0].name, 'Test Community');
    });

    test('updateCommunity updates a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      community.name = 'Updated Community';
      await communityServices.updateCommunity(community);

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['name'], 'Updated Community');
    });

    test('deleteCommunity deletes a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      await communityServices.deleteCommunity('1');

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.exists, isFalse);
    });

    test('requestToJoinCommunity adds a user to pending members', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      await communityServices.requestToJoinCommunity('1', 'user1');

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['pendingMembers'], contains('user1'));
    });

    test('approveJoinRequest moves a user from pending to members', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
        pendingMembers: ['user1'],
      );
      await communityServices.createCommunity(community);

      await communityServices.approveJoinRequest('1', 'user1');
      verify(userServices.addUserToCommunity('user1', '1'));

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['pendingMembers'], isEmpty);
      expect(snapshot.data()!['members'], isNotEmpty);
      expect(snapshot.data()!['members'][0]['userId'], 'user1');
    });

    test('rejectJoinRequest removes a user from pending members', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
        pendingMembers: ['user1'],
      );
      await communityServices.createCommunity(community);

      await communityServices.rejectJoinRequest('1', 'user1');

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['pendingMembers'], isEmpty);
    });

    test('joinCommunity adds a user to a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      await communityServices.joinCommunity('1', 'user1');
      verify(userServices.addUserToCommunity('user1', '1'));

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['members'], isNotEmpty);
      expect(snapshot.data()!['members'][0]['userId'], 'user1');
    });

    test('leaveCommunity removes a user from a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
        members: [
          CommunityMemberModel(
            userId: 'user1',
            communityId: '1',
          )
        ],
      );
      await communityServices.createCommunity(community);

      await communityServices.leaveCommunity('1', 'user1');
      verify(userServices.removeUserFromCommunity('user1', '1'));

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['members'], isEmpty);
    });

    test('updateMember updates a member in a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
        members: [
          CommunityMemberModel(
            userId: 'user1',
            communityId: '1',
          )
        ],
      );
      await communityServices.createCommunity(community);

      final member = CommunityMemberModel(
        userId: 'user1',
        communityId: '1',
        role: CommunityRole.admin,
        permissions: CommunityAdminPermissions(canCreateHatim: true),
      );
      await communityServices.updateMember('1', member);

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['members'], isNotEmpty);
      expect(
          snapshot.data()!['members'][0]['role'], CommunityRole.admin.index);
    });

    test('addZikirToCommunity adds a zikir to a community', () async {
      final community = CommunityModel(
        id: '1',
        name: 'Test Community',
        description: 'Test Description',
        createdBy: 'admin',
      );
      await communityServices.createCommunity(community);

      final zikir = ZikirModel(
        id: '1',
        title: 'Test Zikir',
        description: 'Test Description',
      );
      await communityServices.addZikirToCommunity('1', zikir);

      final snapshot =
          await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['zikirs'], isNotEmpty);
      expect(snapshot.data()!['zikirs'][0]['title'], 'Test Zikir');
    });
  });
}
