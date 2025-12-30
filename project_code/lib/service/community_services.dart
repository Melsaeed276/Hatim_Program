import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hatim_program/models/community_member_model.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/service/user_services.dart';

import '../models/community_model.dart';
import 'services_base.dart';

class CommunityServices extends ServicesBase {
  late final UserServices _userServices;

  CommunityServices({UserServices? userServices})
      : _userServices = userServices ?? UserServices();

  // Create a new community and add it to the database
  Future<bool> createCommunity(CommunityModel community) async {
    try {
      await communityDb.doc(community.id).set(community.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Get a community by its ID
  Future<CommunityModel?> getCommunityById(String communityId) async {
    try {
      var data = await communityDb.doc(communityId).get();
      if (data.exists) {
        return CommunityModel.fromJson(data.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  // Get all communities a user is a member of
  Future<List<CommunityModel>> getCommunitiesForUser(String userId) async {
    try {
      // Because Firestore does not support querying an array of maps with an 'array-contains' filter,
      // we must first fetch the user's document to get their list of community IDs.
      final user = await _userServices.getUserByPhoneNumber(userId);
      if (user == null || user.communityIds.isEmpty) {
        return [];
      }

      // Then, we can fetch the communities using a 'whereIn' query on the community IDs.
      final communityData = await communityDb
          .where(FieldPath.documentId, whereIn: user.communityIds)
          .get();
      return communityData.docs
          .map((e) => CommunityModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  // Update a community's data
  Future<bool> updateCommunity(CommunityModel community) async {
    try {
      await communityDb.doc(community.id).update(community.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Delete a community
  Future<bool> deleteCommunity(String communityId) async {
    try {
      await communityDb.doc(communityId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Request to join a community
  Future<bool> requestToJoinCommunity(String communityId, String userId) async {
    try {
      await communityDb.doc(communityId).update({
        'pendingMembers': FieldValue.arrayUnion([userId])
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Approve a join request
  Future<bool> approveJoinRequest(String communityId, String userId) async {
    try {
      await communityDb.doc(communityId).update({
        'pendingMembers': FieldValue.arrayRemove([userId])
      });
      await joinCommunity(communityId, userId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Reject a join request
  Future<bool> rejectJoinRequest(String communityId, String userId) async {
    try {
      await communityDb.doc(communityId).update({
        'pendingMembers': FieldValue.arrayRemove([userId])
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Add a user to a community's member list
  Future<bool> joinCommunity(String communityId, String userId) async {
    try {
      final newMember = CommunityMemberModel(
        userId: userId,
        communityId: communityId,
      );
      await communityDb.doc(communityId).update({
        'members': FieldValue.arrayUnion([newMember.toJson()])
      });
      await _userServices.addUserToCommunity(userId, communityId);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Remove a user from a community's member list
  Future<bool> leaveCommunity(String communityId, String userId) async {
    try {
      var community = await getCommunityById(communityId);
      if (community != null) {
        final member = community.members.firstWhere((m) => m.userId == userId);
        await communityDb.doc(communityId).update({
          'members': FieldValue.arrayRemove([member.toJson()])
        });
        await _userServices.removeUserFromCommunity(userId, communityId);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Update a user's role and permissions in a community
  Future<bool> updateMember(
      String communityId, CommunityMemberModel member) async {
    try {
      final communityRef = communityDb.doc(communityId);
      await dbInstance.runTransaction((transaction) async {
        final snapshot = await transaction.get(communityRef);
        final community = CommunityModel.fromJson(snapshot.data()!);
        final oldMember =
            community.members.firstWhere((m) => m.userId == member.userId);
        transaction.update(communityRef, {
          'members': FieldValue.arrayRemove([oldMember.toJson()])
        });
        transaction.update(communityRef, {
          'members': FieldValue.arrayUnion([member.toJson()])
        });
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Add a Hatim program to a community
  Future<bool> addHatimToCommunity(String communityId, HatimModel hatim) async {
    try {
      await communityDb.doc(communityId).update({
        'hatimPrograms': FieldValue.arrayUnion([hatim.toJson()])
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Add a Zikir to a community
  Future<bool> addZikirToCommunity(String communityId, ZikirModel zikir) async {
    try {
      await communityDb.doc(communityId).update({
        'zikirs': FieldValue.arrayUnion([zikir.toJson()])
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  // Get all communities
  Future<List<CommunityModel>> getAllCommunities() async {
    try {
      var data = await communityDb.get();
      return data.docs.map((e) => CommunityModel.fromJson(e.data())).toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
