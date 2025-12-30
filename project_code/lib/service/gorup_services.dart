import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/service/services_base.dart';
import 'group_creation_service.dart';

class GroupServices extends ServicesBase implements GroupServiceInterface {
  // get all groups
  @override
  Future<List<GroupModel>> getAllGroups() async {
    try {
      var data = await groupsDb.get();
      if (data.docs.isNotEmpty) {
        if (kDebugMode) {
          print(
            'groups data: ${data.docs.map((e) => GroupModel.fromJson(e.data())).toList()}',
          );
        }

        /// convert the data to a list of GroupModel
        List<GroupModel> groups = data.docs
            .map((e) => GroupModel.fromJson(e.data()))
            .toList();

        ///check for each group if the status is active then get the hatimRounds
        for (GroupModel group in groups) {
          if (group.status == GroupStatus.active) {
            var hatims = await getHatimsOfGroup(group.groupID);
            group.hatimRounds = hatims;
          }
        }

        return groups;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('groups data error:$e');
      }
      return [];
    }
  }

  /// Get groups created by a specific admin (by adminId field)
  @override
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId) async {
    try {
      final data = await groupsDb.where('adminId', isEqualTo: adminId).get();
      if (data.docs.isEmpty) return [];

      final groups = data.docs
          .map((e) => GroupModel.fromJson(e.data()))
          .toList();

      for (final group in groups) {
        if (group.status == GroupStatus.active) {
          final hatims = await getHatimsOfGroup(group.groupID);
          group.hatimRounds = hatims;
        }
      }

      return groups;
    } catch (e) {
      if (kDebugMode) {
        print('getGroupsCreatedByAdmin error: $e');
      }
      return [];
    }
  }

  // get group by ID
  @override
  Future<GroupModel?> getGroupByID(String groupID) async {
    try {
      if (kDebugMode) {
        print('GROUP_SERVICE: getGroupByID called with groupID = $groupID');
      }
      
      var data = await groupsDb.doc(groupID).get();

      if (kDebugMode) {
        print('GROUP_SERVICE: Document exists = ${data.exists}');
        print('GROUP_SERVICE: Document data = ${data.data()}');
      }

      // check if it is not null
      if (data.data() == null) {
        if (kDebugMode) {
          print('GROUP_SERVICE: No data found for groupID = $groupID');
        }
        return null;
      } else {
        ///convert the data to GroupModel
        GroupModel group = GroupModel.fromJson(data.data()!);

        if (kDebugMode) {
          print('GROUP_SERVICE: Group parsed successfully');
          print('GROUP_SERVICE: Group status = ${group.status}');
        }

        ///check if the group status is active then get the hatimRounds
        if (group.status == GroupStatus.active) {
          if (kDebugMode) {
            print('GROUP_SERVICE: Group is active, fetching hatim rounds');
          }
          var hatims = await getHatimsOfGroup(group.groupID);
          group.hatimRounds = hatims;
          
          if (kDebugMode) {
            print('GROUP_SERVICE: Loaded ${hatims.length} hatim rounds');
          }
        }

        return group;
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('GROUP_SERVICE ERROR in getGroupByID: $e');
        print('GROUP_SERVICE Stack trace: $stackTrace');
      }
      return null;
    }
  }

  // update group with transaction for consistency
  @override
  Future<void> updateGroup(GroupModel group) async {
    try {
      if (kDebugMode) {
        print('=== GROUP_SERVICE: updateGroup START ===');
        print('GROUP_SERVICE: Group ID: ${group.groupID}');
        print('GROUP_SERVICE: Status: ${group.status}');
        print('GROUP_SERVICE: Round: ${group.round}');
        print('GROUP_SERVICE: Users count: ${group.usersID.length}');
        print('GROUP_SERVICE: Hatim rounds count: ${group.hatimRounds.length}');
      }

      final groupData = group.toJson();
      
      if (kDebugMode) {
        print('GROUP_SERVICE: Group JSON data keys: ${groupData.keys.toList()}');
        print('GROUP_SERVICE: Full JSON data: $groupData');
      }

      // Update the group document directly without transaction first
      if (kDebugMode) {
        print('GROUP_SERVICE: Calling groupsDb.doc(${group.groupID}).set()');
      }
      
      await groupsDb.doc(group.groupID).set(groupData, SetOptions(merge: true));
      
      if (kDebugMode) {
        print('GROUP_SERVICE: Group document updated successfully');
      }

      // If the group status is active, create hatim rounds
      if (group.status == GroupStatus.active && group.hatimRounds.isNotEmpty) {
        if (kDebugMode) {
          print('Creating ${group.hatimRounds.length} hatim rounds');
        }
        
        // Create hatim rounds in batches to avoid overwhelming Firestore
        WriteBatch batch = dbInstance.batch();
        int batchCount = 0;
        
        for (HatimRoundModel hatimRound in group.hatimRounds) {
          final hatimDocRef = groupsDb
              .doc(group.groupID)
              .collection('hatimRounds')
              .doc(hatimRound.roundID.toString());

          // Check if hatim round already exists to avoid overwriting
          final hatimDoc = await hatimDocRef.get();
          if (!hatimDoc.exists) {
            final hatimData = hatimRound.toJson();
            if (kDebugMode) {
              print('Batching hatim round ${hatimRound.roundID}: $hatimData');
            }
            batch.set(hatimDocRef, hatimData);
            batchCount++;
            
            // Commit batch every 500 operations (Firestore limit)
            if (batchCount >= 500) {
              await batch.commit();
              batch = dbInstance.batch();
              batchCount = 0;
            }
          }
        }
        
        // Commit any remaining operations
        if (batchCount > 0) {
          await batch.commit();
        }
        
        if (kDebugMode) {
          print('Hatim rounds created successfully');
        }
      }
      
      if (kDebugMode) {
        print('Group update completed successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error updating group: $e');
        print('Error type: ${e.runtimeType}');
        print('Stack trace: $stackTrace');
        
        // Try to extract the actual error from wrapped exceptions
        if (e.toString().contains('Dart exception')) {
          try {
            // Try to access error property for JavaScript interop errors
            final dynamic errorObj = e;
            if (errorObj is Error) {
              print('Error details: ${errorObj.toString()}');
            }
          } catch (extractError) {
            print('Could not extract error details: $extractError');
          }
        }
      }
      rethrow; // Re-throw to allow caller to handle the error
    }
  }

  ///get hatims of the group
  Future<List<HatimRoundModel>> getHatimsOfGroup(String groupID) async {
    try {
      var data = await groupsDb.doc(groupID).collection('hatimRounds').get();
      if (data.docs.isNotEmpty) {
        if (kDebugMode) {
          //print('hatims data: ${data.docs.map((e) => HatimRoundModel.fromJson(e.data())).toList()}');
        }
        return data.docs
            .map((e) => HatimRoundModel.fromJson(e.data()))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('hatims data:$e');
      }
      return [];
    }
  }

  // add group with transaction to prevent race conditions
  @override
  Future<void> addGroup(GroupModel group) async {
    try {
      await dbInstance.runTransaction((transaction) async {
        // Check if group already exists
        final groupDoc = await transaction.get(groupsDb.doc(group.groupID));
        if (groupDoc.exists) {
          throw Exception('Group with ID ${group.groupID} already exists');
        }

        // Create the group document
        transaction.set(groupsDb.doc(group.groupID), group.toJson());

        // If the group becomes active immediately (userCount == usersID.length),
        // we need to create hatim rounds atomically
        if (group.status == GroupStatus.active &&
            group.hatimRounds.isNotEmpty) {
          for (HatimRoundModel hatimRound in group.hatimRounds) {
            final hatimDocRef = groupsDb
                .doc(group.groupID)
                .collection('hatimRounds')
                .doc(hatimRound.roundID.toString());
            transaction.set(hatimDocRef, hatimRound.toJson());
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding group: $e');
      }
      rethrow; // Re-throw to allow caller to handle the error
    }
  }

  //delete group
  Future<void> deleteGroup(String groupID) async {
    try {
      await groupsDb.doc(groupID).delete();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Delete a group as admin, also cleaning up members' user docs.
  /// - deletes hatimRounds subcollection docs (if any)
  /// - removes groupId from each member's users/{id}.groups array
  /// - deletes the group doc
  @override
  Future<void> deleteGroupAsAdmin(String groupId) async {
    try {
      final groupRef = groupsDb.doc(groupId);
      final snap = await groupRef.get();
      final data = snap.data();
      if (data == null) return;

      final users = (data['users'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();

      // Delete hatimRounds docs (if any)
      final hatimsSnap = await groupRef.collection('hatimRounds').get();

      WriteBatch batch = dbInstance.batch();
      int opCount = 0;

      Future<void> commitIfNeeded() async {
        if (opCount >= 400) {
          await batch.commit();
          batch = dbInstance.batch();
          opCount = 0;
        }
      }

      for (final doc in hatimsSnap.docs) {
        batch.delete(doc.reference);
        opCount++;
        await commitIfNeeded();
      }

      // Remove groupId from each user's groups array
      for (final uid in users) {
        final userRef = userDb.doc(uid);
        batch.update(userRef, {
          'groups': FieldValue.arrayRemove([groupId]),
        });
        opCount++;
        await commitIfNeeded();
      }

      // Finally delete group doc
      batch.delete(groupRef);
      opCount++;

      await batch.commit();
    } catch (e) {
      if (kDebugMode) {
        print('deleteGroupAsAdmin error: $e');
      }
    }
  }
}
