import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../repo/group_repo.dart';
import '../repo/user_repo.dart';

class UserController extends ChangeNotifier {
  final _userBox = Hive.box('user');

  ThemeMode themeMode = ThemeMode.light;

  ThemeMode get getThemeMode {
    if (getCurrentUserID == '5528695818') {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    return themeMode;
  }

  //userModel field
  UserModel? _userModel;

  static String userID() {
    return Hive.box('user').get('userID', defaultValue: '0');
  }

  //get user model
  UserModel? get userModel {
    if (_userModel != null) {
      return _userModel;
    } else {
      var id = getCurrentUserID;
      if (id != '0') {
        userRepo.getUserByPhoneNumber(id).then((value) {
          getThemeMode;
          userModel = value;
        });
      } else {
        return null;
      }
    }
    return null;
  }

  //set user model
  set userModel(UserModel? userModel) {
    if (userModel == null) {
      if (getCurrentUserID != '0') {
        userRepo.getUserByPhoneNumber(getCurrentUserID).then((value) {
          if (value != null) {
            _userModel = value;
            getThemeMode;
            setUserID = _userModel!.id;
            notifyListeners();
          }
        });
      }
      return;
    }
    _userModel = userModel;
    getThemeMode;
    setUserID = _userModel!.id;
    notifyListeners();
  }

  String get getCurrentUserID => _userBox.get('userID', defaultValue: '0');

  set setUserID(String id) {
    getThemeMode;
    _userBox.put('userID', id);
  }

  // Admin password verification flag
  bool get isAdminPasswordVerified =>
      _userBox.get('adminPasswordVerified', defaultValue: false);

  set setAdminPasswordVerified(bool verified) {
    _userBox.put('adminPasswordVerified', verified);
    notifyListeners();
  }

  void clearAdminPasswordVerification() {
    _userBox.put('adminPasswordVerified', false);
    notifyListeners();
  }

  ///   ----------------- Repo
  final userRepo = UserRepo();

  // get user from repo
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    if (userModel != null && id == null) {
      return userModel;
    } else {
      userModel = await userRepo.getUserByPhoneNumber(id ?? getCurrentUserID);
      return userModel;
    }
  }

  Future<UserModel?> loadUser({String? id}) async {
    return await userRepo.getUserByPhoneNumber(id ?? getCurrentUserID);
  }

  /// add the group of the user  by group ID
  Future<bool> addUserGroup(String groupID) async {
    userModel ??= await getUserByPhoneNumber();
    if (userModel == null) return false;

    // Check if already in group locally
    if (userModel!.groups.contains(groupID)) {
      return true;
    }

    var groupRepo = GroupRepo();
    var result = await groupRepo.addUserToGroup(groupID, userModel!.id);

    if (result.isSuccess) {
      userModel!.groups.add(groupID);
      userModel!.score += 0.1; // Add score for joining group
      await userRepo.updateUser(userModel!);
      notifyListeners();
      return true;
    } else {
      if (kDebugMode) {
        print('Failed to add user to group: ${result.error}');
      }
      return false;
    }
  }

  /// Update user score and stats
  Future<void> updateUserScore({
    double scoreDelta = 0,
    int hatimDelta = 0,
    int chapterDelta = 0,
  }) async {
    userModel ??= await getUserByPhoneNumber();
    if (userModel != null) {
      userModel!.score += scoreDelta;
      userModel!.totalCompletedHatim += hatimDelta;
      userModel!.totalCompletedChapters += chapterDelta;
      await userRepo.updateUser(userModel!);
      notifyListeners();
    }
  }

  void resetUser() {
    _userModel = null;
    setUserID = '0';
    clearAdminPasswordVerification();
    getThemeMode;
    notifyListeners();
  }

  /// get all Group models of the user
  Future<List<GroupModel>> getAllGroupsOfUser() async {
    List<GroupModel> userGroups = [];
    // group list

    if (userGroups.isNotEmpty) {
      userGroups.clear();
    }

    userModel ??= await getUserByPhoneNumber();
    var groupRepo = GroupRepo();

    //for each group id in the user  get the group model
    //  print(userModel!.groups.length);

    for (var groupID in userModel!.groups) {
      var group = await groupRepo.getGroupByID(groupID);
      if (group != null) {
        userGroups.add(group);
      }
    }

    return userGroups;
  }
}
