import 'package:flutter/foundation.dart';

import '../../../core/services_base.dart';
import '../models/models.dart';

/// User Services
/// each user will has phone number and Name
/// each user may belong to multiple groups

class UserServices extends ServicesBase {
  // Simple in-memory cache shared across the app lifetime
  static final Map<String, UserModel?> _userCache = {};

  /// Retrieve a user from the cache if present.
  /// Returns null when the user is not cached **or** not found in Firestore.
  static UserModel? getCachedUser(String phoneNumber) {
    final key = UserModel.processPhoneNumber(phoneNumber);
    return _userCache[key];
  }

  /// Store / update a user in the cache
  static void _cacheUser(UserModel? user) {
    if (user == null) return;
    _userCache[user.id] = user;
  }
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
      var data = await userDb
          .where("phoneNumber", isEqualTo: phoneNumber)
          .get();
      return data.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // get user by id return user model
  Future<UserModel?> getUserByPhoneNumber(String phoneNumber) async {
    // 1. Return immediately if cached
    final cached = UserServices.getCachedUser(phoneNumber);
    if (cached != null) return cached;
    try {
      // by the ID
      var data = await userDb
          .doc(UserModel.processPhoneNumber(phoneNumber))
          .get()
          .then((value) {
            return value;
          });

      if (kDebugMode) {
        final firestoreData = data.data()!;
        print("from server data is ${UserModel.fromJson(firestoreData)}");
        print("Firestore raw data: $firestoreData");
        print(
          "adminPassword field in Firestore: ${firestoreData['adminPassword']}",
        );
        print(
          "adminPassword type: ${firestoreData['adminPassword'].runtimeType}",
        );
      }
      final user = UserModel.fromJson(data.data()!);
      UserServices._cacheUser(user);
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("error from server $e");
      }
      return null;
    }
  }

  // Stream user data - real-time updates from Firestore
  Stream<UserModel?> getUserStream(String phoneNumber) {
    return userDb
        .doc(UserModel.processPhoneNumber(phoneNumber))
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromJson(snapshot.data()!);
      }
      return null;
    });
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

  // remove user from referrals
  Future<bool> removeUserFromReferrals(String userId) async {
    try {
      await userDb.doc(userId).update({'joinedByAdminId': null});
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error removing user from referrals: $e');
      }
      return false;
    }
  }
}
