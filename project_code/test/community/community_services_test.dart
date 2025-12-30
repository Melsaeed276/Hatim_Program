import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/community_model.dart';
import 'package:hatim_program/models/zikir_model.dart';
import 'package:hatim_program/service/community_services.dart';

class MockCommunityServices extends Mock implements CommunityServices {}

void main() {
  group('CommunityServices', () {
    late CommunityServices communityServices;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      communityServices = CommunityServices();
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.exists, isFalse);
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['members'], isNotEmpty);
      expect(snapshot.data()!['members'][0]['role'], CommunityRole.admin.index);
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

      final snapshot = await fakeFirestore.collection('communities').doc('1').get();
      expect(snapshot.data()!['zikirs'], isNotEmpty);
      expect(snapshot.data()!['zikirs'][0]['title'], 'Test Zikir');
    });
  });
}
