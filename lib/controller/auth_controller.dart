import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'user_controller.dart';

class AuthController extends UserController {
  ///   -----------------  Text Editing Controller
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  ///   -----------------  Variables
  bool isPhoneNumberValid = false;

  ///   -----------------  Repo
  // get user info by id
  Future<bool> checkIfUserExist() async {
    return await userRepo.isUserExist(phoneNumberController.text);
  }

  /// add user to repo
  Future<UserModel?> addUser() async {
    var isUserExist =
        await userRepo.getUserByPhoneNumber(phoneNumberController.text);
    if (isUserExist == null) {
      userModel = UserModel(
          name: nameController.text, phoneNumber: phoneNumberController.text);
      await userRepo.addUser(userModel!);
      setUserID = userModel!.id;

      await FirebaseAnalytics.instance.setUserId(id: userModel!.id);
      await FirebaseAnalytics.instance
          .setUserProperty(name: "joined Date:", value: "${DateTime.now()}");

      phoneNumberController.clear();
      nameController.clear();
      return userModel;
    } else {
      return null;
    }
  }

  // get user from repo
  @override
  Future<UserModel?> getUserByPhoneNumber({String? id}) async {
    var user = await userRepo.getUserByPhoneNumber(phoneNumberController.text);

    if (kDebugMode) {
      print("from controller data is $user");
    }
    if (user != null) {
      userModel = user;
      setUserID = user.id;
      return user;
    } else {
      return null;
    }
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
