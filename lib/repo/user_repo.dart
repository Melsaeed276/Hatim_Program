import 'package:flutter/foundation.dart';
import 'package:hatim_program/service/user_services.dart';

import '../models/models.dart';

class UserRepo {

  final service = UserServices();

// get user info by phone number
  Future<UserModel?> getUserByPhoneNumber(String phoneNumber) async {
    var user = await service.getUserByPhoneNumber(phoneNumber);
    return user;
  }



// if user exist with phone number return bool
  Future<bool> isUserExist(String phoneNumber) async {
    var user = await service.getUserByPhoneNumber(phoneNumber);


    if (user != null) {
      return true;
    }else {
      return false;
    }
  }

//  add user to the database and return bool
  Future<bool> addUser(UserModel user) async {
    var isUserExist = await service.getUserByPhoneNumber(user.phoneNumber);
    if (isUserExist == null) {
      await service.addUser(user);
      return true;
    }else {
      return false;
    }
  }

// update user in the database
  Future<bool> updateUser(UserModel user) async {
    return await service.updateUser(user);
  }

// get user groups
  Future<List<String>> getUserGroups(String phoneNumber) async {
    var user = await service.getUserByPhoneNumber(phoneNumber);
    if (user != null) {
      return user.groups;
    }else {
      return [];
    }
  }
}
