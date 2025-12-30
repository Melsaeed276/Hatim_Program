import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/models.dart';
import '../repo/group_repo.dart';
import '../service/group_creation_service.dart';

class GroupController extends ChangeNotifier {
  ///  ----------------- Variables
  final Box _userBox;

  // Cache for group lookups to improve performance
  final Map<String, GroupModel> _groupCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(
    minutes: 5,
  ); // Cache for 5 minutes

  GroupController({Box? userBox, GroupRepoInterface? groupRepo})
    : _userBox = userBox ?? Hive.box('group'),
      _groupRepo = groupRepo ?? GroupRepo() {
    _groupCreationService = GroupCreationService(_groupRepo.groupService);
  }

  String get getCurrentGroupID => _userBox.get('groupID', defaultValue: '0');

  set setGroupID(String id) {
    _userBox.put('groupID', id);
  }

  // group repo field
  final GroupRepoInterface _groupRepo;

  // group creation service field
  late final GroupCreationService _groupCreationService;

  // group model field
  GroupModel? _groupModel;

  // get group model and check if it is null
  GroupModel? get groupModel => _groupModel;

  //set group model
  set groupModel(GroupModel? groupModel) {
    if (groupModel == null) {
      if (getCurrentGroupID != '0') {
        _groupRepo.getGroupByID(getCurrentGroupID).then((value) {
          if (value != null) {
            _groupModel = value;
            setGroupID = _groupModel!.groupID;
            notifyListeners();
          }
        });
      }
      return;
    }
    _groupModel = groupModel;
    setGroupID = _groupModel!.groupID;
    notifyListeners();
  }

  //get group members

  // get group status

  ///  ----------------- Repo
  //get group by ID with caching
  Future<GroupModel?> getGroupByID(String groupID) async {
    // Check current group model first
    if (groupModel != null && groupModel!.groupID == groupID) {
      return groupModel;
    }

    // Check cache
    final now = DateTime.now();
    if (_groupCache.containsKey(groupID) &&
        _cacheTimestamps.containsKey(groupID) &&
        now.difference(_cacheTimestamps[groupID]!) < _cacheDuration) {
      return _groupCache[groupID];
    }

    // Fetch from repository
    final group = await _groupRepo.getGroupByID(groupID);

    // Cache the result if found
    if (group != null) {
      _groupCache[groupID] = group;
      _cacheTimestamps[groupID] = now;
    }

    return group;
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
  Future<List<GroupModel>> getAvailableGroupsForUser({
    required String userID,
  }) async {
    var groups = await getAvailableGroups();
    // remove the groups that the user is already in
    groups.removeWhere((element) => element.usersID.contains(userID));
    return groups;
  }

  // Method to add group to repository with error handling
  Future<GroupCreationResult> addNewGroup(
    String? groupID, {
    required String name,
    required GroupDateType groupDateType,
    required HatimStyle hatimStyle,
    required int count,
    String? adminId,
    String? userId,
  }) async {
    GroupCreationResult result;

    if (groupID == null) {
      // Create group with auto-generated ID
      result = await _groupCreationService.createGroupWithRandomID(
        name: name,
        groupDateType: groupDateType,
        hatimStyle: hatimStyle,
        count: count,
        adminId: adminId,
        userId: userId,
      );
    } else {
      // Create group with custom ID
      result = await _groupCreationService.createGroup(
        groupID: groupID,
        name: name,
        groupDateType: groupDateType,
        hatimStyle: hatimStyle,
        count: count,
        adminId: adminId,
        userId: userId,
      );
    }

    if (result.isSuccess) {
      groupModel = result.group; // Update the cached group model
    }

    return result;
  }

  //add user to the group by userID
  Future<GroupCreationResult> addUserToGroup(
    String groupID,
    String userID,
  ) async {
    return await _groupRepo.addUserToGroup(groupID, userID);
  }

  //get user hatims
  Future<List<HatimRoundModel>> getUserHatimsRound({
    required String userID,
    required String groupID,
  }) async {
    GroupModel? group = await _groupRepo.getGroupByID(groupID);

    // sort the hatims by the roundID
    group!.hatimRounds.sort((a, b) => a.roundID.compareTo(b.roundID));
    return group.hatimRounds;
  }

  // update the group model in the repo
  Future<void> updateGroup(GroupModel group) async {
    await _groupRepo.updateGroup(group);
    // Clear cache for this group since it was updated
    _clearGroupCache(group.groupID);
  }

  /// get groups created by a specific admin
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId) async {
    return await _groupRepo.getGroupsCreatedByAdmin(adminId);
  }

  /// delete group as admin (cleanup members)
  Future<void> deleteGroupAsAdmin(String groupId) async {
    await _groupRepo.deleteGroupAsAdmin(groupId);
  }

  /// remove user from group as admin
  Future<void> removeUserFromGroup(String groupId, String userId) async {
    await _groupRepo.removeUserFromGroup(groupId, userId);
    // Clear cache for this group since it was updated
    _clearGroupCache(groupId);
  }

  /// Generate a unique random group ID
  Future<String> generateUniqueRandomGroupID() async {
    return await _groupCreationService.generateUniqueRandomGroupID();
  }

  /// Clear cache for a specific group ID
  void _clearGroupCache(String groupID) {
    _groupCache.remove(groupID);
    _cacheTimestamps.remove(groupID);
  }

  /// Clear all cache
  void clearAllCache() {
    _groupCache.clear();
    _cacheTimestamps.clear();
  }
}
