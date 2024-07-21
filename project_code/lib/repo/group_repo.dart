
import 'package:hatim_program/service/gorup_services.dart';

import '../models/models.dart';

class GroupRepo{

  //service
  final groupService = GroupServices();

  /// get all groups
  Future<List<GroupModel>> getAllGroups() async {
    return await groupService.getAllGroups();
  }

  /// get all Available groups that user can join
  Future<List<GroupModel>> getAvailableGroups() async {
    var groups = await getAllGroups();
    return groups.where((element) => element.status == GroupStatus.waiting).toList();
  }

  /// get all groups ids
  Future<List<String>> getGroupsIDs() async {
    var groups = await getAllGroups();
    return groups.map((e) => e.groupID).toList();
  }

  // get group data by ID
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
  Future<void> updateGroup(GroupModel group) async {
    //when it update check the status of the group and update it
    await groupService.updateGroup(group);
  }


/// add new group to database
  Future<void> addNewGroup(GroupModel group) async {
      // change the group ID to a new one and add it
      await groupService.addGroup(group);

  }

  /// Add new user to the group
  Future<GroupModel?> addUserToGroup(String groupID, String userID) async {
    GroupModel? group = await getGroupByID(groupID);
    if (group != null) {

      if (group.addUserToGroup(userID)) {

        await updateGroup(group);
        return group;
      }else {
        return group;
      }
    }
    return group;
  }

}