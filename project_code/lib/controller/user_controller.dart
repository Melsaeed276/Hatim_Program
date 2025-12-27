
import 'package:flutter/material.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../repo/group_repo.dart';
import '../repo/user_repo.dart';

class UserController extends ChangeNotifier{

  final _userBox = Hive.box('user');

  Color appColor = Colors.green;


  Color getAppColor() {
    if (getCurrentUserID == '5528695818') {
      appColor = Colors.red;
    }else if (getCurrentUserID == '5065576580') {
      appColor = Colors.blue;
    }else {
      appColor = Colors.green;
    }
    return appColor;
  }


  ThemeMode themeMode = ThemeMode.light;

  ThemeMode get getThemeMode {
    if (getCurrentUserID == '5528695818') {

      themeMode = ThemeMode.dark;

    }else {
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
    }else {
      var id = getCurrentUserID;
      if (id != '0') {
        userRepo.getUserByPhoneNumber(id).then((value) {
          getAppColor();
          getThemeMode;
          userModel = value;
        });
      }else{
        return null;
      }
    }
    return null;

  }
  //set user model
  set userModel(UserModel? userModel){
    if (userModel == null) {
        if (getCurrentUserID != '0') {
          userRepo.getUserByPhoneNumber(getCurrentUserID).then((value) {
            userModel = value;
          });
        }
    }
    _userModel = userModel;
    getThemeMode;
    getAppColor();
    setUserID = _userModel!.id;
    notifyListeners();
  }


  String get getCurrentUserID =>
      _userBox.get('userID', defaultValue: '0');

  set setUserID(String id) {
    getAppColor();
    getThemeMode;
    _userBox.put('userID', id);
  }

  ///   ----------------- Repo
   final userRepo = UserRepo();


// get user from repo
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    if (userModel != null && id == null) {
      return userModel;
    }else {

      userModel = await userRepo.getUserByPhoneNumber(id??getCurrentUserID);
      return userModel;
    }
  }

  Future<UserModel?> loadUser({String? id}) async {
    return await userRepo.getUserByPhoneNumber(id??getCurrentUserID);
  }


  /// add the group of the user  by group ID
  Future<void> addUserGroup(String groupID) async {
    userModel ??= await getUserByPhoneNumber();
    var groupRepo = GroupRepo();

    var didAddedToGroup =  await groupRepo.addUserToGroup(groupID, userModel!.id);

    print(didAddedToGroup);
    print(userModel!.groups);

    if (didAddedToGroup != null) {
      userModel!.groups.add(groupID);
      await userRepo.updateUser(userModel!);
    }
      notifyListeners();
  }



  void resetUser() {
    _userModel = null;
    setUserID = '0';
    getAppColor();
    getThemeMode;
    notifyListeners();
  }

  /// get all Group models of the user
  Future<List<GroupModel>> getAllGroupsOfUser() async {
    List<GroupModel> userGroups = [];
    // group list


    if (userGroups.isNotEmpty){
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