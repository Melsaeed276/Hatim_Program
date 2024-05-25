import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'services_base.dart';

/// User Services
/// each user will has phone number and Name
///  each user will have a list of hatim groups

class UserServices extends ServicesBase {
  // get all users and return a list of users
  Future<List<UserModel>>? getAllUsers() async {
    try {
      var data = await userDb.get();
      return data.docs.map((e) => UserModel.fromJson(e.data())).toList();
    } catch (e) {
      return [];
    }
  }

  // check user by phone number return true or false
  Future<bool> checkUserByPhoneNumber(String phoneNumber) async {
    try {
      var data =
          await userDb.where("phoneNumber", isEqualTo: phoneNumber).get();
      return data.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // get user by id return user model
  Future<UserModel?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      // by the ID
      var data = await userDb.doc(UserModel.processPhoneNumber(phoneNumber)).get().then((value) {
        return value;
      });

      if (kDebugMode) {
        print("from server data is ${UserModel.fromJson(data.data()!)}");
      }
      if (data == null) {
        return null;
      }else {
        return UserModel.fromJson(data.data()!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("error from server $e");
      }
      return null;
    }
  }

  // update user
  Future<bool> updateUser(UserModel user) async {
    try {
      await userDb.doc(user.id).update(user.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // add user and return bool
  Future<bool> addUser(UserModel user) async {
    try {
      await userDb.doc(user.id).set(user.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // add users
  Future<void> addUsers(List<UserModel> users) async {
    try {
      for (var user in users) {
        await userDb.doc(user.id).set(user.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // delete user
  Future<void> deleteUser(String id) async {
    try {
      await userDb.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
