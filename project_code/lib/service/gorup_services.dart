import 'package:flutter/foundation.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/service/services_base.dart';

class GroupServices extends ServicesBase {
  // get all groups
  Future<List<GroupModel>> getAllGroups() async {
    try {
      var data = await groupsDb.get();
      if (data.docs.isNotEmpty) {
        if (kDebugMode) {
          print('groups data: ${data.docs.map((e) => GroupModel.fromJson(e.data())).toList()}');
        }

        /// convert the data to a list of GroupModel
        List<GroupModel> groups = data.docs.map((e) => GroupModel.fromJson(e.data())).toList();

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

  // get group by ID
  Future<GroupModel?> getGroupByID(String groupID) async {
    try {
      var data = await groupsDb.doc(groupID).get();

      // check if it is not null
      if (data.data() == null) {
        return null;
      }else {
        ///convert the data to GroupModel
        GroupModel group = GroupModel.fromJson(data.data()!);

        ///check if the group status is active then get the hatimRounds
        if (group.status == GroupStatus.active) {
          var hatims = await getHatimsOfGroup(group.groupID);
          group.hatimRounds = hatims;
        }

        return group;
      }
    } catch (e) {
      return null;
    }
  }

  // update group
  Future<void> updateGroup(GroupModel group) async {
    try {
      await groupsDb.doc(group.groupID).update(group.toJson());

      //if the group status is active then send the hatimRoundModel List in the database
      if (group.status == GroupStatus.active) {

        /// each hatim has it own ID as the documentID
        for (HatimRoundModel hatimRound in group.hatimRounds) {
          await groupsDb.doc(group.groupID).collection('hatimRounds').doc(hatimRound.roundID.toString()).set(hatimRound.toJson());
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
        return data.docs.map((e) => HatimRoundModel.fromJson(e.data())).toList();
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

  // add group
  Future<void> addGroup(GroupModel group) async {
    try {
      await groupsDb.doc(group.groupID).set(group.toJson());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
}