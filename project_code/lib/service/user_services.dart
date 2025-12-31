import 'package:cloud_firestore/cloud_firestore.dart';
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

  // get users by ids and return a list of users
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }
      var data = await userDb.where(FieldPath.documentId, whereIn: userIds).get();
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
    // Validate phoneNumber is not empty
    if (phoneNumber.isEmpty) {
      if (kDebugMode) {
        print('Error: phoneNumber cannot be empty in getUserByPhoneNumber');
      }
      return null;
    }
    
    // Skip default/placeholder values
    if (phoneNumber == '0') {
      if (kDebugMode) {
        print('Warning: phoneNumber is default value "0" in getUserByPhoneNumber');
      }
      return null;
    }
    
    try {
      final processedPhone = UserModel.processPhoneNumber(phoneNumber);
      // Validate processed phone number is not empty
      if (processedPhone.isEmpty) {
        if (kDebugMode) {
          print('Error: processed phoneNumber is empty in getUserByPhoneNumber. Original: "$phoneNumber"');
        }
        return null;
      }
      
      // by the ID
      var data = await userDb
          .doc(processedPhone)
          .get()
          .then((value) {
        return value;
      });

      if (kDebugMode) {
        print("from server data is ${UserModel.fromJson(data.data()!)}");
      }
      return UserModel.fromJson(data.data()!);
    } catch (e) {
      if (kDebugMode) {
        print("error from server $e");
      }
      return null;
    }
  }

  // update user
  Future<bool> updateUser(UserModel user) async {
    // Validate user.id is not empty
    if (user.id.isEmpty) {
      if (kDebugMode) {
        print('Error: user.id cannot be empty in updateUser');
      }
      return false;
    }
    
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

  // add user to community
  Future<bool> addUserToCommunity(String userId, String communityId) async {
    // Validate userId is not empty
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: userId cannot be empty in addUserToCommunity');
      }
      return false;
    }
    
    try {
      await userDb.doc(userId).update({
        'communityIds': FieldValue.arrayUnion([communityId])
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // remove user from community
  Future<bool> removeUserFromCommunity(
      String userId, String communityId) async {
    // Validate userId is not empty
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: userId cannot be empty in removeUserFromCommunity');
      }
      return false;
    }
    
    try {
      await userDb.doc(userId).update({
        'communityIds': FieldValue.arrayRemove([communityId])
      });
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
    // Validate user.id is not empty
    if (user.id.isEmpty) {
      if (kDebugMode) {
        print('Error: user.id cannot be empty in addUser');
      }
      return false;
    }
    
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
        // Skip users with empty IDs
        if (user.id.isEmpty) {
          if (kDebugMode) {
            print('Warning: Skipping user with empty ID in addUsers');
          }
          continue;
        }
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
    // Validate id is not empty
    if (id.isEmpty) {
      if (kDebugMode) {
        print('Error: id cannot be empty in deleteUser');
      }
      return;
    }
    
    try {
      await userDb.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
