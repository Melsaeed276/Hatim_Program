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
    return await groupService.getGroupByID(groupID);
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
    //when it update check the status of the group and update it
    await groupService.updateGroup(group);
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
      GroupModel? group = await getGroupByID(groupID);
      if (group != null) {
        if (group.addUserToGroup(userID)) {
          await updateGroup(group);
          return GroupCreationResult.success(group: group);
        } else {
          return GroupCreationResult.failure(
            error:
                'Failed to add user to group (group may be full or user already exists)',
          );
        }
      }
      return GroupCreationResult.failure(error: 'Group not found');
    } catch (e) {
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
}
