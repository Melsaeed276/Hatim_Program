import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'user_controller.dart';

class AuthController extends UserController {
  ///   -----------------  Text Editing Controller
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ///   -----------------  Variables
  bool isPhoneNumberValid = false;

  ///   -----------------  Repo
  // get user info by id
  Future<bool> checkIfUserExist() async {
    return await userRepo.isUserExist(phoneNumberController.text);
  }

  /// add user to repo
  Future<UserModel?> addUser() async {
    var isUserExist = await userRepo.getUserByPhoneNumber(
      phoneNumberController.text,
    );
    if (isUserExist == null) {
      userModel = UserModel(
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        joinedByAdminId: null,
        joinedAt: null,
      );

      await userRepo.addUser(userModel!);
      setUserID = userModel!.id;

      phoneNumberController.clear();
      nameController.clear();
      return userModel;
    } else {
      return null;
    }
  }

  // get user from repo (without setting userID - for login verification)
  @override
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    var user = await userRepo.getUserByPhoneNumber(phoneNumberController.text);

    if (kDebugMode) {
      print("from controller data is $user");
    }
    if (user != null) {
      // Don't set userModel or userID here - let login page handle it after password verification
      return user;
    } else {
      return null;
    }
  }

  /// Verify user password for login
  Future<bool> verifyUserPassword(String inputPassword, UserModel user) async {
    if (user.password == null || user.password!.isEmpty) {
      // No password set, allow login
      return true;
    }
    return user.password == inputPassword;
  }

  /// Set password for current user
  Future<bool> setUserPassword(String newPassword) async {
    if (userModel != null) {
      // Create a new UserModel with updated password
      final updatedUser = UserModel(
        name: userModel!.name,
        phoneNumber: userModel!.phoneNumber,
        isAdmin: userModel!.isAdmin,
        isSuperAdmin: userModel!.isSuperAdmin,
        adminPassword: userModel!.adminPassword,
        password: newPassword,
        totalCompletedChapters: userModel!.totalCompletedChapters,
        score: userModel!.score,
        joinedByAdminId: userModel!.joinedByAdminId,
        joinedAt: userModel!.joinedAt,
      );
      // Copy groups
      updatedUser.groups.addAll(userModel!.groups);
      userModel = updatedUser;
      await userRepo.updateUser(userModel!);
      return true;
    }
    return false;
  }

  /// Set admin password for current admin user
  Future<bool> setAdminPassword(String newPassword) async {
    if (userModel != null && userModel!.isAdmin) {
      // Create a new UserModel with updated adminPassword
      final updatedUser = UserModel(
        name: userModel!.name,
        phoneNumber: userModel!.phoneNumber,
        isAdmin: userModel!.isAdmin,
        isSuperAdmin: userModel!.isSuperAdmin,
        adminPassword: newPassword,
        password: userModel!.password,
        totalCompletedChapters: userModel!.totalCompletedChapters,
        score: userModel!.score,
        joinedByAdminId: userModel!.joinedByAdminId,
        joinedAt: userModel!.joinedAt,
      );
      // Copy groups
      updatedUser.groups.addAll(userModel!.groups);
      userModel = updatedUser;
      await userRepo.updateUser(userModel!);
      return true;
    }
    return false;
  }

  /// Check if current user has password set
  bool hasPassword() {
    if (userModel?.isAdmin == true) {
      return userModel?.adminPassword != null &&
          userModel!.adminPassword!.isNotEmpty;
    }
    return userModel?.password != null && userModel!.password!.isNotEmpty;
  }

  ///   ----------------- Functions

  void isPhoneNumberValidChecker() {
    if (phoneNumberController.text.length == 10 &&
        phoneNumberController.text.startsWith('5')) {
      isPhoneNumberValid = true;
    } else {
      isPhoneNumberValid = false;
    }
    notifyListeners();
  }

  bool hasNumbers(String input) {
    return RegExp(r'\d').hasMatch(input);
  }
}
