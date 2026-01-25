import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/auth/models/models.dart';
import '../../../features/auth/repositories/user_repo.dart';

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
  late final UserRepo userRepo = UserRepo();

  // get user from repo
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    if (userModel != null && id == null) {
      return userModel;
    } else {
      userModel = await userRepo.getUserByPhoneNumber(id ?? getCurrentUserID);
      return userModel;
    }
  }

  // Stream user data - real-time updates from Firestore
  Stream<UserModel?> getUserStream({String? id}) {
    return userRepo.getUserStream(id ?? getCurrentUserID);
  }

  Future<UserModel?> loadUser({String? id}) async {
    return await userRepo.getUserByPhoneNumber(id ?? getCurrentUserID);
  }

  /// Update user score and stats
  Future<void> updateUserScore({
    double scoreDelta = 0,
    int chapterDelta = 0,
  }) async {
    userModel ??= await getUserByPhoneNumber();
    if (userModel != null) {
      userModel!.score += scoreDelta;
      userModel!.totalCompletedChapters += chapterDelta;
      await userRepo.updateUser(userModel!);
      notifyListeners();
    }
  }

  /// Update any user's data (not just current user)
  Future<void> updateUserData(UserModel user) async {
    await userRepo.updateUser(user);
    // If this is the current user, update the cached userModel
    if (userModel?.id == user.id) {
      userModel = user;
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

}
