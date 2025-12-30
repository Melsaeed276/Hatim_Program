import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';

void main() {
  group('GroupModel - Group Creation and Activation', () {
    test(
      'Group becomes active when reaching userCount with correct startDate',
      () {
        final group = GroupModel.withCustomInfo(
          groupID: '123456',
          name: 'Test Group 1',
          userCount: 3,
          dateType: GroupDateType.week,
          groupDateCount: 30,
        );

        // Record creation time
        final creationTime = group.createdDate;

        // Add users one by one
        expect(group.status, GroupStatus.waiting);
        expect(group.round, 0);
        expect(group.startDate, isNull);
        expect(group.endDate, isNull);
        expect(group.hatimRounds.length, 0);

        // Add first user
        expect(group.addUserToGroup('user1'), isTrue);
        expect(group.status, GroupStatus.waiting);
        expect(group.round, 0);

        // Add second user
        expect(group.addUserToGroup('user2'), isTrue);
        expect(group.status, GroupStatus.waiting);
        expect(group.round, 0);

        // Add third user - should activate
        final beforeActivation = DateTime.now();
        expect(group.addUserToGroup('user3'), isTrue);
        final afterActivation = DateTime.now();

        // Verify activation
        expect(group.status, GroupStatus.active);
        expect(group.round, 1);
        expect(group.startDate, isNotNull);
        expect(group.endDate, isNotNull);

        // startDate should be activation time (DateTime.now()), not creation time
        expect(
          group.startDate!.isAfter(creationTime) ||
              group.startDate!.isAtSameMomentAs(beforeActivation) ||
              group.startDate!.isBefore(afterActivation),
          isTrue,
        );

        // endDate should be startDate + (30 weeks * 7 days)
        final expectedEndDate = group.startDate!.add(Duration(days: 30 * 7));
        expect(
          group.endDate!.difference(expectedEndDate).inSeconds,
          lessThan(1),
        );

        // Should have created hatimRounds
        expect(group.hatimRounds.length, 30);

        // Verify roundIDs are sequential starting from 1
        for (int i = 0; i < 30; i++) {
          expect(group.hatimRounds[i].roundID, i + 1);
        }
      },
    );

    test('Group activation with day dateType calculates endDate correctly', () {
      final group = GroupModel.withCustomInfo(
        groupID: '789012',
        name: 'Test Group 2',
        userCount: 2,
        dateType: GroupDateType.day,
        groupDateCount: 30,
      );

      // Add users to activate
      group.addUserToGroup('user1');
      group.addUserToGroup('user2');

      expect(group.status, GroupStatus.active);
      expect(group.startDate, isNotNull);
      expect(group.endDate, isNotNull);

      // endDate should be startDate + 30 days (not weeks)
      final expectedEndDate = group.startDate!.add(Duration(days: 30));
      expect(group.endDate!.difference(expectedEndDate).inSeconds, lessThan(1));
    });

    test('Cannot add duplicate user to group', () {
      final group = GroupModel.withCustomInfo(
        groupID: '111111',
        name: 'Test Group 3',
        userCount: 5,
      );

      expect(group.addUserToGroup('user1'), isTrue);
      expect(group.usersID.length, 1);

      // Try to add same user again
      expect(group.addUserToGroup('user1'), isFalse);
      expect(group.usersID.length, 1);
    });

    test('Cannot add user beyond capacity', () {
      final group = GroupModel.withCustomInfo(
        groupID: '222222',
        name: 'Test Group 4',
        userCount: 2,
      );

      expect(group.addUserToGroup('user1'), isTrue);
      expect(group.addUserToGroup('user2'), isTrue);
      expect(group.status, GroupStatus.active);

      // Try to add third user when capacity is 2
      expect(group.addUserToGroup('user3'), isFalse);
      expect(group.usersID.length, 2);
    });

    test('HatimStyle.byRounds assigns same chapter to all users per round', () {
      final group = GroupModel.withCustomInfo(
        groupID: '333333',
        name: 'Test Group 5',
        userCount: 3,
        hatimStyle: HatimStyle.byRounds,
        groupDateCount: 5,
      );

      // Activate group
      group.addUserToGroup('user1');
      group.addUserToGroup('user2');
      group.addUserToGroup('user3');

      // In byRounds style, all users in round 1 should have chapter 1
      final round1 = group.hatimRounds.firstWhere((r) => r.roundID == 1);
      expect(round1.getJuzForUser('user1', group.usersID, group.hatimStyle), 1);
      expect(round1.getJuzForUser('user2', group.usersID, group.hatimStyle), 1);
      expect(round1.getJuzForUser('user3', group.usersID, group.hatimStyle), 1);
    });

    test(
      'HatimStyle.allTogetherInOneHatim assigns different chapters by user index',
      () {
        final group = GroupModel.withCustomInfo(
          groupID: '444444',
          name: 'Test Group 6',
          userCount: 3,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          groupDateCount: 5,
        );

        // Activate group
        group.addUserToGroup('user1');
        group.addUserToGroup('user2');
        group.addUserToGroup('user3');

        // In allTogetherInOneHatim style, users should have different chapters
        // Round 1: user1 gets chapter 1, user2 gets chapter 2, user3 gets chapter 3
        final round1 = group.hatimRounds.firstWhere((r) => r.roundID == 1);
        expect(
          round1.getJuzForUser('user1', group.usersID, group.hatimStyle),
          1,
        );
        expect(
          round1.getJuzForUser('user2', group.usersID, group.hatimStyle),
          2,
        );
        expect(
          round1.getJuzForUser('user3', group.usersID, group.hatimStyle),
          3,
        );

        // Round 2: user1 gets chapter 2, user2 gets chapter 3, user3 gets chapter 4
        final round2 = group.hatimRounds.firstWhere((r) => r.roundID == 2);
        expect(
          round2.getJuzForUser('user1', group.usersID, group.hatimStyle),
          2,
        );
        expect(
          round2.getJuzForUser('user2', group.usersID, group.hatimStyle),
          3,
        );
        expect(
          round2.getJuzForUser('user3', group.usersID, group.hatimStyle),
          4,
        );
      },
    );

    test('generateRandomGroupID returns 6-digit number', () {
      for (int i = 0; i < 100; i++) {
        final id = GroupModel.generateRandomGroupID();
        expect(id, greaterThanOrEqualTo(100000));
        expect(id, lessThanOrEqualTo(999999));
        // Should be exactly 6 digits
        expect(id.toString().length, 6);
      }
    });

    test('Group with custom info initializes correctly', () {
      final group = GroupModel.withCustomInfo(
        groupID: '555555',
        name: 'Test Group 7',
        userCount: 10,
        groupDateCount: 20,
        dateType: GroupDateType.day,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(group.groupID, '555555');
      expect(group.name, 'Test Group 7');
      expect(group.userCount, 10);
      expect(group.groupDateCount, 20);
      expect(group.dateType, GroupDateType.day);
      expect(group.hatimStyle, HatimStyle.byRounds);
      expect(group.status, GroupStatus.waiting);
      expect(group.round, 0);
      expect(group.usersID.length, 0);
      expect(group.hatimRounds.length, 0);
    });

    test('Group with randomID generates valid 6-digit ID', () {
      final group = GroupModel.randomID(name: 'Random Group');

      final groupIDInt = int.tryParse(group.groupID);
      expect(groupIDInt, isNotNull);
      expect(groupIDInt!, greaterThanOrEqualTo(100000));
      expect(groupIDInt, lessThanOrEqualTo(999999));
      expect(group.groupID.length, 6);
      expect(group.name, 'Random Group');
    });
  });
}
