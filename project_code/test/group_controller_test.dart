import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hatim_program/controller/group_controller.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/repo/group_repo.dart';
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

  @override
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await Future.delayed(Duration(milliseconds: 1));
    _groups[groupId]?.usersID.remove(userId);
  }

  @override
  Future<void> updateGroupDetails({
    required String groupId,
    String? name,
    int? userCount,
    int? groupDateCount,
    GroupDateType? dateType,
    DateTime? plannedStartDate,
    int? hijriStartYear,
    int? hijriStartMonth,
    int? hijriStartDay,
    int? startHour,
    int? startMinute,
  }) async {
    await Future.delayed(Duration(milliseconds: 1));
    final group = _groups[groupId];
    if (group != null) {
      if (name != null) group.name = name;
      if (userCount != null) group.userCount = userCount;
      if (groupDateCount != null) group.groupDateCount = groupDateCount;
      if (dateType != null) group.dateType = dateType;
      if (plannedStartDate != null) group.plannedStartDate = plannedStartDate;
      if (hijriStartYear != null) group.hijriStartYear = hijriStartYear;
      if (hijriStartMonth != null) group.hijriStartMonth = hijriStartMonth;
      if (hijriStartDay != null) group.hijriStartDay = hijriStartDay;
      if (startHour != null) group.startHour = startHour;
      if (startMinute != null) group.startMinute = startMinute;
    }
  }

  void addTestGroup(GroupModel group) {
    _groups[group.groupID] = group;
  }
}

// Simple test GroupRepo that stores groups in memory
class TestGroupRepo implements GroupRepoInterface {
  final TestGroupServices _testServices = TestGroupServices();

  @override
  TestGroupServices get groupService => _testServices;

  TestGroupServices get testServices => _testServices;

  @override
  Future<List<GroupModel>> getAllGroups() async {
    return await _testServices.getAllGroups();
  }

  @override
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId) async {
    // For testing, just return all groups
    return await _testServices.getAllGroups();
  }

  @override
  Future<List<GroupModel>> getAvailableGroups() async {
    // For testing, return all groups
    return await _testServices.getAllGroups();
  }

  @override
  Future<List<String>> getGroupsIDs() async {
    final groups = await _testServices.getAllGroups();
    return groups.map((g) => g.groupID).toList();
  }

  @override
  Future<GroupModel?> getGroupByID(String groupID) async {
    return await _testServices.getGroupByID(groupID);
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    await _testServices.updateGroup(group);
  }

  @override
  Future<void> addNewGroup(GroupModel group) async {
    await _testServices.addGroup(group);
  }

  @override
  Future<GroupCreationResult> addUserToGroup(String groupID, String userID) async {
    final group = await _testServices.getGroupByID(groupID);
    if (group == null) {
      return GroupCreationResult.failure(error: 'Group not found');
    }

    if (group.addUserToGroup(userID)) {
      await _testServices.updateGroup(group);
      return GroupCreationResult.success(group: group);
    } else {
      return GroupCreationResult.failure(error: 'group may be full');
    }
  }

  @override
  Future<void> deleteGroupAsAdmin(String groupId) async {
    // For testing, just remove from map
    // Note: This is a simplified implementation for testing
  }

  @override
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await _testServices.removeUserFromGroup(groupId, userId);
  }

  @override
  Future<void> updateGroupDetails({
    required String groupId,
    String? name,
    int? userCount,
    int? groupDateCount,
    GroupDateType? dateType,
    DateTime? plannedStartDate,
    int? hijriStartYear,
    int? hijriStartMonth,
    int? hijriStartDay,
    int? startHour,
    int? startMinute,
  }) async {
    await _testServices.updateGroupDetails(
      groupId: groupId,
      name: name,
      userCount: userCount,
      groupDateCount: groupDateCount,
      dateType: dateType,
      plannedStartDate: plannedStartDate,
      hijriStartYear: hijriStartYear,
      hijriStartMonth: hijriStartMonth,
      hijriStartDay: hijriStartDay,
      startHour: startHour,
      startMinute: startMinute,
    );
  }

  void addTestGroup(GroupModel group) {
    _testServices.addTestGroup(group);
  }
}

void main() {
  late Box testBox;

  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('test/hive');
    testBox = await Hive.openBox('test_group');
  });

  tearDown(() {
    testBox.clear();
  });

  group('GroupCreationService', () {
    test('validateGroupParameters - valid parameters', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: 'Valid Group Name',
        count: 30,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
      );

      expect(error, isNull);
    });

    test('validateGroupParameters - invalid group ID length', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '12345', // 5 digits
        name: 'Valid Group Name',
        count: 30,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('must be exactly 6 digits'));
    });

    test('validateGroupParameters - invalid group ID format', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '12a456', // contains letter
        name: 'Valid Group Name',
        count: 30,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('containing only numbers'));
    });

    test('validateGroupParameters - empty group name', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: '', // empty
        count: 30,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('3-50 characters long'));
    });

    test('validateGroupParameters - group name too short', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: 'AB', // too short
        count: 30,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('3-50 characters long'));
    });

    test('validateGroupParameters - group name too long', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: 'A' * 51, // too long
        count: 30,
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('3-50 characters long'));
    });

    test('validateGroupParameters - invalid count (too low)', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: 'Valid Group Name',
        count: 0, // too low
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('at least 1 user'));
    });

    test('validateGroupParameters - invalid count (too high)', () {
      final service = GroupCreationService(TestGroupServices());

      final error = service.validateGroupParameters(
        groupID: '123456',
        name: 'Valid Group Name',
        count: 101, // too high
        hatimStyle: HatimStyle.byRounds,
      );

      expect(error, contains('cannot exceed 100 users'));
    });

    test('createGroup - successfully creates group', () async {
      final services = TestGroupServices();
      final service = GroupCreationService(services);

      final result = await service.createGroup(
        groupID: '123456',
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
        count: 30,
        adminId: 'admin1',
      );

      expect(result.isSuccess, true);
      expect(result.group, isNotNull);
      final group = result.group!;
      expect(group.groupID, '123456');
      expect(group.name, 'Test Group');
      expect(group.adminId, 'admin1');
      expect(group.userCount, 30);

      // Verify it was saved
      final savedGroup = await services.getGroupByID('123456');
      expect(savedGroup, isNotNull);
    });

    test('createGroup - returns error for existing group ID', () async {
      final services = TestGroupServices();
      final service = GroupCreationService(services);

      // Create first group
      final firstResult = await service.createGroup(
        groupID: '123456',
        name: 'First Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
        count: 30,
      );
      expect(firstResult.isSuccess, true);

      // Try to create another with same ID
      final secondResult = await service.createGroup(
        groupID: '123456',
        name: 'Second Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
        count: 30,
      );

      expect(secondResult.isSuccess, false);
      expect(secondResult.error, contains('already exists'));
    });

    test('createGroup - returns error for invalid parameters', () async {
      final services = TestGroupServices();
      final service = GroupCreationService(services);

      final result = await service.createGroup(
        groupID: '12345', // invalid
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.allTogetherInOneHatim,
        count: 30,
      );

      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });
  });

  group('GroupController - getGroupByID caching behavior', () {
    test('Returns cached group only when IDs match', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Create and set a group
      final group1 = GroupModel.withCustomInfo(groupID: '111111', name: 'Test Group 1', userCount: 5);
      controller.groupModel = group1;

      // Query for the same ID - should return cached group
      final result1 = await controller.getGroupByID('111111');
      expect(result1, isNotNull);
      expect(result1!.groupID, '111111');
      expect(result1, same(group1)); // Should be the same instance

      // Query for different ID - should NOT return cached group, should query repo
      final group2 = GroupModel.withCustomInfo(groupID: '222222', name: 'Test Group 2', userCount: 5);
      testRepo.addTestGroup(group2);

      final result2 = await controller.getGroupByID('222222');
      expect(result2, isNotNull);
      expect(result2!.groupID, '222222');
      expect(result2.groupID, isNot(equals(group1.groupID)));
    });

    test('Queries repo when cached group ID does not match', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Set a group with ID '111111'
      final group1 = GroupModel.withCustomInfo(groupID: '111111', name: 'Test Group 1', userCount: 5);
      controller.groupModel = group1;

      // Add a different group to repo
      final group2 = GroupModel.withCustomInfo(groupID: '999999', name: 'Test Group 2', userCount: 10);
      testRepo.addTestGroup(group2);

      // Query for '999999' - should query repo, not return cached '111111'
      final result = await controller.getGroupByID('999999');
      expect(result, isNotNull);
      expect(result!.groupID, '999999');
      expect(result.userCount, 10);
    });

    test('Queries repo when no group is cached', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // No group cached
      expect(controller.groupModel, isNull);

      // Add group to repo
      final group = GroupModel.withCustomInfo(groupID: '123456', name: 'Test Group', userCount: 5);
      testRepo.addTestGroup(group);

      // Query should hit repo
      final result = await controller.getGroupByID('123456');
      expect(result, isNotNull);
      expect(result!.groupID, '123456');
    });

    test('Returns null when group does not exist in repo', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Query for non-existent group
      final result = await controller.getGroupByID('nonexistent');
      expect(result, isNull);
    });
  });

  group('GroupController - addNewGroup', () {
    test('Creates group with custom name', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addNewGroup(
        '123456',
        name: 'My Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 5,
      );

      // Verify result is successful
      expect(result.isSuccess, true);
      expect(result.group, isNotNull);
      expect(result.error, isNull);

      // Verify group was created in repo
      final group = await testRepo.getGroupByID('123456');
      expect(group, isNotNull);
      expect(group!.groupID, '123456');
      expect(group.name, 'My Test Group');
      expect(group.userCount, 5);
      expect(group.dateType, GroupDateType.week);
      expect(group.hatimStyle, HatimStyle.byRounds);
    });

    test('Creates group with random ID when groupID is null', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addNewGroup(
        null,
        name: 'Random Group Name',
        groupDateType: GroupDateType.day,
        hatimStyle: HatimStyle.byRounds,
        count: 10,
      );

      // Verify result is successful
      expect(result.isSuccess, true);
      expect(result.group, isNotNull);
      expect(result.error, isNull);

      // Should have created a group with random 6-digit ID
      final allGroups = await testRepo.getAllGroups();
      expect(allGroups.length, 1);

      final group = allGroups.first;
      final groupIDInt = int.tryParse(group.groupID);
      expect(groupIDInt, isNotNull);
      expect(groupIDInt!, greaterThanOrEqualTo(100000));
      expect(groupIDInt, lessThanOrEqualTo(999999));
      expect(group.name, 'Random Group Name');
    });

    test('Returns error when group ID already exists', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Create first group
      await controller.addNewGroup(
        '123456',
        name: 'First Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 5,
      );

      // Try to create another group with same ID
      final result = await controller.addNewGroup(
        '123456',
        name: 'Second Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 5,
      );

      // Should fail
      expect(result.isSuccess, false);
      expect(result.group, isNull);
      expect(result.error, contains('already exists'));
    });

    test('Returns error for invalid group ID format', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addNewGroup(
        '12345', // Only 5 digits
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 5,
      );

      // Should fail due to validation
      expect(result.isSuccess, false);
      expect(result.group, isNull);
      expect(result.error, contains('must be exactly 6 digits'));
    });

    test('Returns error for invalid group name', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addNewGroup(
        '123456',
        name: '', // Empty name
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 5,
      );

      // Should fail due to validation
      expect(result.isSuccess, false);
      expect(result.group, isNull);
      expect(result.error, contains('3-50 characters long'));
    });

    test('Returns error for invalid user count', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addNewGroup(
        '123456',
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 0, // Invalid count
      );

      // Should fail due to validation
      expect(result.isSuccess, false);
      expect(result.group, isNull);
      expect(result.error, contains('at least 1 user'));
    });
  });

  group('GroupController - addUserToGroup', () {
    test('Successfully adds user to group', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Create a group first (using byRounds to allow flexible count)
      final createResult = await controller.addNewGroup(
        '123456',
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 3,
      );
      expect(createResult.isSuccess, true);

      // Add user to group
      final addResult = await controller.addUserToGroup('123456', 'user1');
      expect(addResult.isSuccess, true);
      expect(addResult.group, isNotNull);
      expect(addResult.group!.usersID.contains('user1'), true);
    });

    test('Fails to add user when group is full', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      // Create a group with capacity 2 (using byRounds to allow flexible count)
      final createResult = await controller.addNewGroup(
        '123456',
        name: 'Test Group',
        groupDateType: GroupDateType.week,
        hatimStyle: HatimStyle.byRounds,
        count: 2,
      );
      expect(createResult.isSuccess, true);

      // Add two users (fills the group)
      await controller.addUserToGroup('123456', 'user1');
      await controller.addUserToGroup('123456', 'user2');

      // Try to add third user
      final addResult = await controller.addUserToGroup('123456', 'user3');
      expect(addResult.isSuccess, false);
      expect(addResult.error, contains('group may be full'));
    });

    test('Fails when group does not exist', () async {
      final testRepo = TestGroupRepo();
      final controller = GroupController(userBox: testBox, groupRepo: testRepo);

      final result = await controller.addUserToGroup('nonexistent', 'user1');
      expect(result.isSuccess, false);
      expect(result.error, contains('Group not found'));
    });
  });

  group('GroupCreationResult', () {
    test('success result has correct properties', () {
      final group = GroupModel.withCustomInfo(
        groupID: '123456',
        name: 'Test Group',
        userCount: 5,
      );

      final result = GroupCreationResult.success(group: group);
      expect(result.isSuccess, true);
      expect(result.group, same(group));
      expect(result.error, isNull);
    });

    test('failure result has correct properties', () {
      const errorMessage = 'Test error';
      final result = GroupCreationResult.failure(error: errorMessage);
      expect(result.isSuccess, false);
      expect(result.group, isNull);
      expect(result.error, errorMessage);
    });
  });
}
