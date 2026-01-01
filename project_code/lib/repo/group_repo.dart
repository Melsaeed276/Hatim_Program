import 'package:flutter/foundation.dart';
import 'package:hatim_program/service/gorup_services.dart';
import 'package:hatim_program/service/group_creation_service.dart';

import '../models/models.dart';

// Interface for GroupRepo to allow for testing
abstract class GroupRepoInterface {
  GroupServiceInterface get groupService;
  Future<List<GroupModel>> getAllGroups();
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId);
  Future<List<GroupModel>> getAvailableGroups();
  Future<List<String>> getGroupsIDs();
  Future<GroupModel?> getGroupByID(String groupID);
  Future<void> updateGroup(GroupModel group);
  Future<void> addNewGroup(GroupModel group);
  Future<GroupCreationResult> addUserToGroup(String groupID, String userID);
  Future<void> deleteGroupAsAdmin(String groupId);
  Future<void> removeUserFromGroup(String groupId, String userId);
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
  });
}

class GroupRepo implements GroupRepoInterface {
  //service
  @override
  final GroupServiceInterface groupService;

  GroupRepo({GroupServiceInterface? groupService})
    : groupService = groupService ?? GroupServices();

  /// get all groups
  @override
  Future<List<GroupModel>> getAllGroups() async {
    return await groupService.getAllGroups();
  }

  /// get groups created by a specific admin
  @override
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId) async {
    return await groupService.getGroupsCreatedByAdmin(adminId);
  }

  /// get all Available groups that user can join
  @override
  Future<List<GroupModel>> getAvailableGroups() async {
    var groups = await getAllGroups();
    return groups
        .where((element) => element.status == GroupStatus.waiting)
        .toList();
  }

  /// get all groups ids
  @override
  Future<List<String>> getGroupsIDs() async {
    var groups = await getAllGroups();
    return groups.map((e) => e.groupID).toList();
  }

  // get group data by ID
  @override
  Future<GroupModel?> getGroupByID(String groupID) async {
    if (kDebugMode) {
      print('GROUP_REPO: getGroupByID called with groupID = $groupID');
    }
    
    final result = await groupService.getGroupByID(groupID);
    
    if (kDebugMode) {
      print('GROUP_REPO: getGroupByID result = ${result != null ? "found" : "null"}');
    }
    
    return result;
  }

  /// update group status
  Future<void> updateGroupStatus(String groupID, GroupStatus status) async {
    GroupModel? group = await getGroupByID(groupID);
    if (group != null) {
      group.status = status;
      await updateGroup(group);
    }
  }

  /// update group
  @override
  Future<void> updateGroup(GroupModel group) async {
    if (kDebugMode) {
      print('=== GROUP_REPO: updateGroup START ===');
      print('GROUP_REPO: Calling groupService.updateGroup');
    }
    
    //when it update check the status of the group and update it
    await groupService.updateGroup(group);
    
    if (kDebugMode) {
      print('=== GROUP_REPO: updateGroup COMPLETE ===');
    }
  }

  /// add new group to database
  @override
  Future<void> addNewGroup(GroupModel group) async {
    // change the group ID to a new one and add it
    await groupService.addGroup(group);
  }

  /// Add new user to the group with proper error handling
  @override
  Future<GroupCreationResult> addUserToGroup(
    String groupID,
    String userID,
  ) async {
    try {
      if (kDebugMode) {
        print('=== GROUP_REPO: addUserToGroup START ===');
        print('GROUP_REPO: groupID = $groupID');
        print('GROUP_REPO: userID = $userID');
      }
      
      GroupModel? group = await getGroupByID(groupID);
      
      if (kDebugMode) {
        print('GROUP_REPO: Retrieved group = ${group?.toString()}');
      }
      
      if (group != null) {
        if (kDebugMode) {
          print('GROUP_REPO: Group found, attempting to add user');
          print('GROUP_REPO: Current users count = ${group.usersID.length}');
          print('GROUP_REPO: Max users = ${group.userCount}');
          print('GROUP_REPO: Current status = ${group.status}');
        }
        
        bool addResult = group.addUserToGroup(userID);
        
        if (kDebugMode) {
          print('GROUP_REPO: addUserToGroup result = $addResult');
          print('GROUP_REPO: New users count = ${group.usersID.length}');
          print('GROUP_REPO: New status = ${group.status}');
          print('GROUP_REPO: Hatim rounds count = ${group.hatimRounds.length}');
        }
        
        if (addResult) {
          if (kDebugMode) {
            print('GROUP_REPO: Calling updateGroup...');
          }
          
          await updateGroup(group);
          
          if (kDebugMode) {
            print('GROUP_REPO: updateGroup completed successfully');
            print('=== GROUP_REPO: addUserToGroup SUCCESS ===');
          }
          
          return GroupCreationResult.success(group: group);
        } else {
          if (kDebugMode) {
            print('GROUP_REPO: Failed to add user (full or already exists)');
          }
          return GroupCreationResult.failure(
            error:
                'Failed to add user to group (group may be full or user already exists)',
          );
        }
      }
      
      if (kDebugMode) {
        print('GROUP_REPO: Group not found');
      }
      return GroupCreationResult.failure(error: 'Group not found');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('=== GROUP_REPO: addUserToGroup ERROR ===');
        print('GROUP_REPO ERROR: $e');
        print('GROUP_REPO ERROR type: ${e.runtimeType}');
        print('GROUP_REPO Stack trace: $stackTrace');
      }
      return GroupCreationResult.failure(
        error: 'Error adding user to group: ${e.toString()}',
      );
    }
  }

  /// delete a group as admin (also cleans up member user docs)
  @override
  Future<void> deleteGroupAsAdmin(String groupId) async {
    await groupService.deleteGroupAsAdmin(groupId);
  }

  /// remove a user from a group as admin
  @override
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await groupService.removeUserFromGroup(groupId, userId);
  }

  /// Update group details (admin edit functionality)
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
    await groupService.updateGroupDetails(
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
}
