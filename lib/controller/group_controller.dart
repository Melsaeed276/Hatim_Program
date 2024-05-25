
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';
import '../repo/group_repo.dart';

class GroupController extends ChangeNotifier {

  ///  ----------------- Variables
  final _userBox = Hive.box('group');



  String get getCurrentGroupID =>
      _userBox.get('groupID', defaultValue: '0');

  set setGroupID(String id) {
    _userBox.put('groupID', id);
  }

  // group repo field
  final GroupRepo _groupRepo = GroupRepo();

  // group model field
GroupModel? _groupModel;

  // get group model and check if it is null
  GroupModel? get groupModel => _groupModel;

  //set group model
  set groupModel(GroupModel? groupModel) {
    if (groupModel == null) {
      if (getCurrentGroupID != '0') {
        _groupRepo.getGroupByID(getCurrentGroupID).then((value) {
          groupModel = value;
        });
      }
    }
    _groupModel = groupModel;
    setGroupID = _groupModel!.groupID;
    notifyListeners();
  }



//get group members

// get group status




  ///  ----------------- Repo
  //get group by ID
  Future<GroupModel?> getGroupByID(String groupID) async {
    if (groupModel != null) {
      return groupModel;
    } else {
      return _groupRepo.getGroupByID(groupID);
    }
  }

  // get all groups
  Future<List<GroupModel>> getAllGroups() async {
    return await _groupRepo.getAllGroups();
  }

  // get all available groups
  Future<List<GroupModel>> getAvailableGroups() async {
    var groups = await _groupRepo.getAvailableGroups();
    return groups;
  }

  // get all avaılable groups for the user
  Future<List<GroupModel>> getAvailableGroupsForUser({required String userID}) async {
    var groups = await getAvailableGroups();
    // remove the groups that the user is already in
    groups.removeWhere((element) => element.usersID.contains(userID));
    return groups;
  }


// Method to add group to repository
  Future<void> addNewGroup(String? name) async {
    // if name is null then random
    if (name == null) {
      //create a new group
      var group = GroupModel.randomID();
      //groupModel = group;
      await _groupRepo.addNewGroup(group);
    } else {
      //create a new group
      var group = GroupModel(groupID: name);
     // groupModel = group;
      await _groupRepo.addNewGroup(group);
    }
  }

  //add user to the group by userID
  Future<void> addUserToGroup(String groupID,String userID) async {

    await _groupRepo.addUserToGroup(groupID, userID);
  }

  //get user hatims
  Future<List<HatimRoundModel>> getUserHatimsRound({required String userID,required String groupID}) async {
    GroupModel? group =  await _groupRepo.getGroupByID(groupID);

    // sort the hatims by the roundID
    group!.hatimRounds.sort((a, b) => a.roundID.compareTo(b.roundID));
    return group.hatimRounds;
  }

  // update the group model in the repo
  Future<void> updateGroup(GroupModel group) async {
    await _groupRepo.updateGroup(group);
  }

}
