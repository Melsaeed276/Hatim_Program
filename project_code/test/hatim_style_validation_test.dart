import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/service/group_creation_service.dart';

// Mock GroupServices for testing
class TestGroupServices implements GroupServiceInterface {
  final Map<String, GroupModel> _groups = {};

  @override
  Future<GroupModel?> getGroupByID(String groupID) async {
    await Future.delayed(Duration(milliseconds: 1));
    return _groups[groupID];
  }

  @override
  Future<void> addGroup(GroupModel group) async {
    await Future.delayed(Duration(milliseconds: 1));
    if (_groups.containsKey(group.groupID)) {
      throw Exception('Group with ID ${group.groupID} already exists');
    }
    _groups[group.groupID] = group;
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    await Future.delayed(Duration(milliseconds: 1));
    _groups[group.groupID] = group;
  }

  @override
  Future<List<GroupModel>> getAllGroups() async {
    await Future.delayed(Duration(milliseconds: 1));
    return _groups.values.toList();
  }

  @override
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId) async {
    await Future.delayed(Duration(milliseconds: 1));
    return _groups.values.where((group) => group.adminId == adminId).toList();
  }

  @override
  Future<void> deleteGroupAsAdmin(String groupId) async {
    await Future.delayed(Duration(milliseconds: 1));
    _groups.remove(groupId);
  }

  void addTestGroup(GroupModel group) {
    _groups[group.groupID] = group;
  }

  void clear() {
    _groups.clear();
  }
}

void main() {
  late GroupCreationService groupCreationService;
  late TestGroupServices testGroupServices;

  setUp(() {
    testGroupServices = TestGroupServices();
    groupCreationService = GroupCreationService(testGroupServices);
  });

  tearDown(() {
    testGroupServices.clear();
  });

  group('HatimStyle Validation Tests', () {
    group('All Together in One Hatim Style', () {
      test('should succeed with exactly 30 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 30,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 30);
        expect(result.group!.hatimStyle, HatimStyle.allTogetherInOneHatim);
        expect(result.error, isNull);
      });

      test('should fail with less than 30 users (29)', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 29,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('exactly 30'));
      });

      test('should fail with more than 30 users (31)', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 31,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('exactly 30'));
      });

      test('should fail with 1 user', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 1,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('exactly 30'));
      });

      test('should fail with 100 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 100,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('exactly 30'));
      });

      test('should fail with 0 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 0,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('exactly 30'));
      });
    });

    group('By Rounds Style', () {
      test('should succeed with 1 user', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 1,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 1);
        expect(result.group!.hatimStyle, HatimStyle.byRounds);
      });

      test('should succeed with 30 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 30,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 30);
      });

      test('should succeed with 50 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 50,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 50);
      });

      test('should succeed with 100 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 100,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 100);
      });

      test('should fail with 0 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 0,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('at least 1'));
      });

      test('should fail with 101 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 101,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('cannot exceed 100'));
      });
    });

    group('By Challenge Style', () {
      test('should succeed with 1 user', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 1,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 1);
        expect(result.group!.hatimStyle, HatimStyle.byChallenge);
      });

      test('should succeed with 15 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 15,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 15);
      });

      test('should succeed with 30 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 30,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 30);
      });

      test('should succeed with 100 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 100,
        );

        expect(result.isSuccess, true);
        expect(result.group, isNotNull);
        expect(result.group!.userCount, 100);
      });

      test('should fail with 0 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 0,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('at least 1'));
      });

      test('should fail with 101 users', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 101,
        );

        expect(result.isSuccess, false);
        expect(result.group, isNull);
        expect(result.error, isNotNull);
        expect(result.error, contains('cannot exceed 100'));
      });
    });

    group('Edge Cases and Boundary Tests', () {
      test('should handle negative count for allTogetherInOneHatim', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: -1,
        );

        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
      });

      test('should handle negative count for byRounds', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: -5,
        );

        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
      });

      test('should handle very large count for byChallenge', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 1000,
        );

        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
        expect(result.error, contains('cannot exceed 100'));
      });
    });

    group('Multiple Group Creation Tests', () {
      test('should create multiple groups with different styles', () async {
        final result1 = await groupCreationService.createGroup(
          groupID: '111111',
          name: 'Group 1',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 30,
        );

        final result2 = await groupCreationService.createGroup(
          groupID: '222222',
          name: 'Group 2',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 15,
        );

        final result3 = await groupCreationService.createGroup(
          groupID: '333333',
          name: 'Group 3',
          groupDateType: GroupDateType.day,
          hatimStyle: HatimStyle.byChallenge,
          count: 50,
        );

        expect(result1.isSuccess, true);
        expect(result2.isSuccess, true);
        expect(result3.isSuccess, true);

        expect(result1.group!.userCount, 30);
        expect(result2.group!.userCount, 15);
        expect(result3.group!.userCount, 50);
      });

      test('should prevent duplicate group IDs', () async {
        final result1 = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Group 1',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byRounds,
          count: 20,
        );

        final result2 = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Group 2',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.byChallenge,
          count: 25,
        );

        expect(result1.isSuccess, true);
        expect(result2.isSuccess, false);
        expect(result2.error, contains('already exists'));
      });
    });

    group('Integration with GroupDateType', () {
      test('should work with week date type and allTogetherInOneHatim', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.week,
          hatimStyle: HatimStyle.allTogetherInOneHatim,
          count: 30,
        );

        expect(result.isSuccess, true);
        expect(result.group!.dateType, GroupDateType.week);
        expect(result.group!.hatimStyle, HatimStyle.allTogetherInOneHatim);
      });

      test('should work with day date type and byRounds', () async {
        final result = await groupCreationService.createGroup(
          groupID: '123456',
          name: 'Test Group',
          groupDateType: GroupDateType.day,
          hatimStyle: HatimStyle.byRounds,
          count: 20,
        );

        expect(result.isSuccess, true);
        expect(result.group!.dateType, GroupDateType.day);
        expect(result.group!.hatimStyle, HatimStyle.byRounds);
      });
    });
  });

  group('validateGroupParameters Direct Tests', () {
    test('should return error for allTogetherInOneHatim with count != 30', () {
      final error = groupCreationService.validateGroupParameters(
        groupID: '123456',
        name: 'Test Group',
        count: 25,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      expect(error, isNotNull);
      expect(error, contains('exactly 30'));
    });

    test('should return null for allTogetherInOneHatim with count = 30', () {
      final error = groupCreationService.validateGroupParameters(
        groupID: '123456',
        name: 'Test Group',
        count: 30,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      expect(error, isNull);
    });

    test('should return null for byRounds with valid count', () {
      final error = groupCreationService.validateGroupParameters(
        groupID: '123456',
        name: 'Test Group',
        count: 50,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, isNull);
    });

    test('should return error for byRounds with count > 100', () {
      final error = groupCreationService.validateGroupParameters(
        groupID: '123456',
        name: 'Test Group',
        count: 101,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, isNotNull);
      expect(error, contains('cannot exceed 100'));
    });

    test('should return error for byChallenge with count < 1', () {
      final error = groupCreationService.validateGroupParameters(
        groupID: '123456',
        name: 'Test Group',
        count: 0,
        hatimStyle: HatimStyle.byChallenge,
      );

      expect(error, isNotNull);
      expect(error, contains('at least 1'));
    });
  });
}
