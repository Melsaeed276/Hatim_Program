import 'dart:math';

import 'package:flutter/foundation.dart';

import 'hatim_model.dart';

/// group status enum
// 1- active
// 2- waiting to start
// 3- finished
enum GroupStatus { waiting, active, finished }

enum GroupDateType { week, day }

enum HatimStyle { allTogetherInOneHatim, byRounds, byChallenge }

/// Calendar type for the group - immutable after creation
/// Admin chooses this when creating a group and cannot change it later
enum GroupCalendarType { hijri, gregorian }

extension GroupCalendarTypeExtension on GroupCalendarType {
  static GroupCalendarType? fromJson(dynamic json) {
    if (json is int && json >= 0 && json < GroupCalendarType.values.length) {
      return GroupCalendarType.values[json];
    }
    return null;
  }

  String get displayName {
    switch (this) {
      case GroupCalendarType.hijri:
        return 'Hijri (Islamic)';
      case GroupCalendarType.gregorian:
        return 'Gregorian';
    }
  }
}

extension HatimStyleExtension on HatimStyle {
  // check the if the json input is valid and return the hatim style
  static HatimStyle? fromJson(dynamic json) {
    if (json is int) {
      return HatimStyle.values[json];
    }
    return null;
  }

  // name of the hatim style
  String get name {
    switch (this) {
      case HatimStyle.allTogetherInOneHatim:
        return 'All Together in One Hatim';
      case HatimStyle.byRounds:
        return 'By Rounds';
      case HatimStyle.byChallenge:
        return 'By Challenge';
    }
  }
}

/// group model
class GroupModel {
  /// group id
  late final String groupID;

  /// creator admin id (optional)
  /// if set, only this admin should manage this group from the Admin Config page
  String? adminId;

  /// group name (display name shown to users)
  late final String name;

  /// The General hatim round (30 rounds )
  late int round;

  /// list of users
  List<String> usersID = [];

  /// list of hatim rounds (30 rounds)
  List<HatimRoundModel> hatimRounds = [];

  /// Calendar type for this group (immutable after creation)
  /// Determines whether dates are stored/displayed as Hijri or Gregorian
  late final GroupCalendarType calendarType;

  /// Hijri start date fields (used when calendarType == hijri)
  int? hijriStartYear;
  int? hijriStartMonth;
  int? hijriStartDay;

  /// Start time fields (shared by both calendar types)
  int? startHour;
  int? startMinute;

  /// Derived Gregorian start date (computed from Hijri or stored directly for Gregorian)
  /// Used for scheduling calculations
  DateTime? startDate;

  late final DateTime createdDate;

  /// Derived end date (computed from startDate + duration)
  DateTime? endDate;

  /// Planned start date set by admin at creation (before group becomes active)
  /// If set, this will be used instead of DateTime.now() when group activates
  DateTime? plannedStartDate;

  int groupDateCount;
  int userCount;

  HatimStyle hatimStyle = HatimStyle.allTogetherInOneHatim;

  /// group status
  /// by default the group will be waiting
  /// if the users are 30 users then the group will be active and round will be 1
  /// if the round is more than 30 then the group will be finished
  GroupStatus status = GroupStatus.waiting;
  late final GroupDateType dateType;

  // constructor
  ///  when you create a either give a name or it will be generated randomly
  ///  the round will be 0 by default
  ///  the status will be waiting by default
  ///  the start date will be when  the status is active
  ///  when the status is active it will calculate the end date from that date
  ///  the created date will be the current date when the group is created

  // constructor with group name

  GroupModel({
    required this.groupID,
    required this.name,
    this.adminId,
    this.dateType = GroupDateType.week,
    this.userCount = 30,
    this.groupDateCount = 30,
    this.calendarType = GroupCalendarType.hijri,
  }) {
    round = 0;
    status = GroupStatus.waiting;
    hatimStyle = HatimStyle.allTogetherInOneHatim;
    createdDate = DateTime.now();
  }

  GroupModel.withCustomInfo({
    required this.groupID,
    required this.name,
    this.adminId,
    this.groupDateCount = 30,
    this.userCount = 30,
    this.hatimStyle = HatimStyle.allTogetherInOneHatim,
    this.dateType = GroupDateType.week,
    this.calendarType = GroupCalendarType.hijri,
    this.startDate,
    this.endDate,
    this.plannedStartDate,
    this.hijriStartYear,
    this.hijriStartMonth,
    this.hijriStartDay,
    this.startHour,
    this.startMinute,
  }) {
    round = 0;
    hatimStyle = hatimStyle;
    status = GroupStatus.waiting;
    createdDate = DateTime.now();
  }

  // constructor with random group name
  GroupModel.randomID({
    required this.name,
    this.adminId,
    this.dateType = GroupDateType.week,
    this.userCount = 30,
    this.groupDateCount = 30,
    this.hatimStyle = HatimStyle.allTogetherInOneHatim,
    this.calendarType = GroupCalendarType.hijri,
  }) {
    groupID = generateRandomGroupID().toString();
    round = 0;

    status = GroupStatus.waiting;
    createdDate = DateTime.now();
  }

  void _assignHatim() {
    if (kDebugMode) {
      print('GROUP_MODEL: _assignHatim() called');
      print('GROUP_MODEL: Users count: ${usersID.length}, userCount: $userCount');
      print('GROUP_MODEL: Will create $groupDateCount rounds');
    }
    
    if (usersID.length == userCount) {
      for (int i = 0; i < groupDateCount; i++) {
        // Lean Model: only store roundID
        hatimRounds.add(HatimRoundModel(roundID: i + 1));
        
        if (kDebugMode && i < 3) {
          print('GROUP_MODEL: Created round ${i + 1}');
        }
      }
      
      if (kDebugMode) {
        print('GROUP_MODEL: All $groupDateCount rounds created successfully');
      }
    } else {
      if (kDebugMode) {
        print('GROUP_MODEL: Cannot assign hatim - users count mismatch');
      }
    }
  }

  // set status of the group
  GroupStatus setStatus() {
    /// by default the group will be waiting
    /// if the users are 30 users then the group will be active and round will be 1
    /// if the round is more than 30 then the group will be finished
    if (usersID.isEmpty) {
      status = GroupStatus.waiting;
    } else if (usersID.length == userCount && round == 0) {
      status = GroupStatus.active;
      round = 1;
    } else if (round > 30) {
      status = GroupStatus.finished;
    } else {
      status = GroupStatus.waiting;
      round = 0;
    }

    return status;
  }

  ///write by Mohammed
  // from json
  GroupModel.fromJson(Map<String, dynamic> json)
    : groupID = json['group_id'] ?? 'default_group_id',
      adminId = json['adminId']?.toString(),
      name =
          json['name'] ??
          (json['group_id'] ??
              'default_group_id'), // Fallback to groupID for backward compatibility
      round = json['round'] ?? 0,
      userCount = json['userCount'] ?? 30,
      groupDateCount = json['groupDateCount'] ?? 30,
      usersID = (json['users'] as List<dynamic>? ?? [])
          .map((x) => x.toString())
          .toList(),
      status =
          (json['status'] != null &&
              json['status'] >= 0 &&
              json['status'] < GroupStatus.values.length)
          ? GroupStatus.values[json['status']]
          : GroupStatus.waiting,
      dateType =
          (json['dateType'] != null &&
              json['dateType'] >= 0 &&
              json['dateType'] < GroupDateType.values.length)
          ? GroupDateType.values[json['dateType']]
          : GroupDateType.week,
      // Default existing groups to Hijri calendar type for backward compatibility
      calendarType =
          GroupCalendarTypeExtension.fromJson(json['calendarType']) ??
          GroupCalendarType.hijri,
      hatimStyle =
          HatimStyleExtension.fromJson(json['hatimStyle']) ??
          HatimStyle.allTogetherInOneHatim,
      createdDate = json['created_date'] != null
          ? DateTime.parse(json['created_date'])
          : DateTime.now(),
      startDate = json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate = json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      plannedStartDate = json['planned_start_date'] != null
          ? DateTime.parse(json['planned_start_date'])
          : null,
      // Hijri date fields
      hijriStartYear = json['hijriStartYear'] as int?,
      hijriStartMonth = json['hijriStartMonth'] as int?,
      hijriStartDay = json['hijriStartDay'] as int?,
      // Time fields
      startHour = json['startHour'] as int?,
      startMinute = json['startMinute'] as int?;

  ///write by Mohammed
  // to json
  Map<String, dynamic> toJson() {
    if (kDebugMode) {
      print('GROUP_MODEL: toJson() called');
      print('GROUP_MODEL: groupID type = ${groupID.runtimeType}, value = $groupID');
      print('GROUP_MODEL: adminId type = ${adminId?.runtimeType}, value = $adminId');
      print('GROUP_MODEL: usersID length = ${usersID.length}');
      print('GROUP_MODEL: status = $status (index: ${status.index})');
      print('GROUP_MODEL: calendarType = $calendarType');
    }
    
    try {
      final json = {
        'group_id': groupID,
        if (adminId != null) 'adminId': adminId,
        'name': name,
        'round': round,
        'users': usersID,
        'groupDateCount': groupDateCount,
        'userCount': userCount,
        'dateType': dateType.index,
        'calendarType': calendarType.index,
        'hatimStyle': hatimStyle.index,
        'status': status.index,
        'created_date': createdDate.toIso8601String(),
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        if (plannedStartDate != null)
          'planned_start_date': plannedStartDate!.toIso8601String(),
        // Hijri date fields
        if (hijriStartYear != null) 'hijriStartYear': hijriStartYear,
        if (hijriStartMonth != null) 'hijriStartMonth': hijriStartMonth,
        if (hijriStartDay != null) 'hijriStartDay': hijriStartDay,
        // Time fields
        if (startHour != null) 'startHour': startHour,
        if (startMinute != null) 'startMinute': startMinute,
      };
      
      if (kDebugMode) {
        print('GROUP_MODEL: toJson() completed successfully');
      }
      
      return json;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('GROUP_MODEL ERROR in toJson(): $e');
        print('GROUP_MODEL Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  ///write by Cengizhan
  /// add user to group
  ///  ---------- Rules ----------
  ///  ----------Active Status----------
  /// if the group has 30 users then the group will be active
  /// if the group is active then the start date will be the current date
  /// if the group is active then the end date will be the start date + 30 weeks
  /// if the group is active then the round will be 1
  ///  ----------Waiting Status----------
  ///  if the group is less then 30 user the status will be waiting and can add more users
  ///  the round still 0
  bool addUserToGroup(String newUser) {
    if (kDebugMode) {
      print('=== GROUP_MODEL: addUserToGroup START ===');
      print('GROUP_MODEL: Current state: ${toString()}');
      print('GROUP_MODEL: Adding user: $newUser');
      print('GROUP_MODEL: Current users count: ${usersID.length}');
      print('GROUP_MODEL: Max users: $userCount');
    }

    /// check if  the users is already in the group
    if (usersID.length >= userCount) {
      /// if the user is more than 30  in the group then it will not add  any new  user
      if (kDebugMode) {
        print("GROUP_MODEL: Cannot add - group is full");
      }
      return false;
    } else {
      /// if the user is less than 30  in the group then it will add  new  user
      /// check if the user is exist in the group
      if (usersID.contains(newUser)) {
        if (kDebugMode) {
          print("GROUP_MODEL: Cannot add - user already in group");
        }
        return false;
      } else {
        if (kDebugMode) {
          print("GROUP_MODEL: Adding user to list");
        }
        usersID.add(newUser);
      }

      /// if the users become 30 then the group will be active and stop taking new users
      if (usersID.length == userCount) {
        if (kDebugMode) {
          print("GROUP_MODEL: *** GROUP IS NOW FULL - STARTING HATIM ***");
          print("GROUP_MODEL: Users count: ${usersID.length}");
        }

        ///status will be active
        status = GroupStatus.active;
        if (kDebugMode) {
          print("GROUP_MODEL: Status set to: $status");
        }

        ///round will be 1
        round = 1;
        if (kDebugMode) {
          print("GROUP_MODEL: Round set to: $round");
        }

        /// startDate: use plannedStartDate if set by admin, otherwise use current time
        if (plannedStartDate != null) {
          startDate = plannedStartDate;
          if (kDebugMode) {
            print("GROUP_MODEL: Using planned start date: $startDate");
          }
        } else {
          startDate = DateTime.now();
          if (kDebugMode) {
            print("GROUP_MODEL: Start date set to now: $startDate");
          }
        }

        switch (dateType) {
          case GroupDateType.week:
            endDate = startDate!.add(Duration(days: groupDateCount * 7));
            break;

          case GroupDateType.day:
            endDate = startDate!.add(Duration(days: groupDateCount));
            break;
        }
        
        if (kDebugMode) {
          print("GROUP_MODEL: End date set to: $endDate");
        }

        ///endDate will be the startDate + 30 weeks

        ///assign the hatim to the users
        if (kDebugMode) {
          print("GROUP_MODEL: Calling _assignHatim()");
        }
        _assignHatim();
        
        if (kDebugMode) {
          print("GROUP_MODEL: _assignHatim() completed");
          print("GROUP_MODEL: Created ${hatimRounds.length} hatim rounds");
        }
      } else {
        /// if the users is less than 30 then the group will be waiting
        if (status != GroupStatus.waiting) {
          status = GroupStatus.waiting;
          if (kDebugMode) {
            print("GROUP_MODEL: Status set to waiting");
          }
        }
      }
      
      if (kDebugMode) {
        print('=== GROUP_MODEL: addUserToGroup SUCCESS ===');
      }
      return true;
    }
  }

  ///write by Cengizhan
  /// delete user from group
  /// Updated: Admin can now remove users even from active groups
  void deleteUser(String userid) {
    if (usersID.isNotEmpty) {
      ///check if the group is not empty
      if (usersID.contains(userid)) {
        ///check if the user is in the group

        ///get the index of the user
        int index = usersID.indexOf(userid);

        ///remove the user from the group
        usersID.removeAt(index);

        // If the group was active and now has fewer users than required,
        // set status back to waiting
        if (status == GroupStatus.active && usersID.length < userCount) {
          status = GroupStatus.waiting;
          round = 0;
          // Clear dates when reverting to waiting status
          startDate = null;
          endDate = null;
          // Clear hatim rounds as they're no longer valid
          hatimRounds.clear();
          
          if (kDebugMode) {
            print("Group reverted to waiting status after user removal");
          }
        }
      }
    }
  }

  ///write by Mohammed
  /// get the available users
  int getHowMuchLeftPlaceInTheGroup() {
    return userCount - usersID.length;
  }

  ///write by Mohammed
  /// get the current hatim of the group in total
  /// In this method, it will return the current Hatim of the group in total.
  /// if all users have completed the Hatim of hatimRound 1, the method will return 2.
  /// if all users have completed the Hatim of hatimRound 2, the method will return 3.
  /// if all users have no completed the Hatim of hatimRound 3, the method will return 3.
  int getCurrentHatim() {
    int count = 1;

    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.isAllUserCompleted(usersID.length)) {
        count++;
      }
    }

    return count;
  }

  ///write by Mohammed And Cengizhan
  /// get the current hatim of the user
  int getCurrentHatimOfUser(String userID) {
    int count = 1;

    for (HatimRoundModel hatimRound in hatimRounds) {
      if (hatimRound.isHatimCompleted(userID)) {
        if (hatimRound.roundID == groupDateCount) {
          return groupDateCount;
        } else {
          count++;
        }
      } else {
        // User hasn't finished this round, so they are currently in this round
        return count;
      }
    }
    return count;
  }

  // get the hatimGroups
  List<HatimRoundModel> getHatimGroups() {
    hatimRounds.sort((a, b) => a.roundID.compareTo(b.roundID));
    return hatimRounds;
  }

  /// Check if user has completed ALL hatim rounds in this group
  bool isUserFinishedAllRounds(String userID) {
    if (hatimRounds.isEmpty) return false;
    // Check if every round is completed by this user
    return hatimRounds.every((round) => round.isHatimCompleted(userID));
  }

  ///Write by Mohammed
  /// get the current hatim Chapter of the user
  int getCurrentHatimChapterOfUser(String userID) {
    // get the current hatim round of the user
    int activeRound = getCurrentHatimOfUser(userID);

    HatimRoundModel? round = hatimRounds.firstWhere(
      (element) => element.roundID == activeRound,
      orElse: () => hatimRounds.first,
    );

    return round.getJuzForUser(userID, usersID, hatimStyle);
  }

  ///Write by Mohammed
  /// update the hatim completion status of a user
  void completeHatimOfUser(String userID) {
    int activeRound = getCurrentHatimOfUser(userID);

    for (int i = 0; i < hatimRounds.length; i++) {
      if (hatimRounds[i].roundID == activeRound) {
        if (!hatimRounds[i].completedUserIDs.contains(userID)) {
          // Create a new list with the updated user to maintain immutability if desired,
          // or just modify if state permits.
          hatimRounds[i].completedUserIDs.add(userID);
        }
      }
    }
  }

  ///Write by Mohammed
  /// get the completed hatims of  the round
  ///  In this method, it will take the roundID as inout to get all the users who have completed the round.
  List<String> getCompletedHatim(int roundID) {
    final round = hatimRounds.firstWhere((r) => r.roundID == roundID);
    return round.completedUserIDs;
  }

  List<String> getNotCompletedHatim(int roundID) {
    final round = hatimRounds.firstWhere((r) => r.roundID == roundID);
    return usersID.where((id) => !round.completedUserIDs.contains(id)).toList();
  }

  /// Write by Mohammed
  /// How Many days left for the group to finish
  /// This method will calculate the number of days left for the group to finish.
  int getDaysLeft() {
    if (status == GroupStatus.active) {
      return endDate!.difference(DateTime.now()).inDays;
    } else {
      return 0;
    }
  }

  /// Write by Mohammed
  // get all hatims of the user
  List<String> getAllHatimsOfUser(String userID) {
    return hatimRounds
        .map(
          (round) =>
              round.getJuzForUser(userID, usersID, hatimStyle).toString(),
        )
        .toList();
  }

  List<String> getNotCopleatedHatimRoundsOfUser(String userID) {
    return hatimRounds
        .where((r) => !r.isHatimCompleted(userID))
        .map((r) => r.roundID.toString())
        .toList();
  }

  List<String> getCopleatedHatimRoundsOfUser(String userID) {
    return hatimRounds
        .where((r) => r.isHatimCompleted(userID))
        .map((r) => r.roundID.toString())
        .toList();
  }

  List<String> getCopleatedHatimChatersOfUser(String userID) {
    return hatimRounds
        .where((r) => r.isHatimCompleted(userID))
        .map((r) => r.getJuzForUser(userID, usersID, hatimStyle).toString())
        .toList();
  }

  ///Get all the Hatim rounds of the user by the user ID
  List<HatimRoundModel>? getUserHatimsRound(String userID) {
    // In the lean model, users are technically in all rounds.
    // They just either have finished them or not.
    return hatimRounds;
  }

  ///Write by Cengizhan
  // generate a random groupID that is a 6-digit number (100000-999999)
  static int generateRandomGroupID() {
    // Generate a random number between 100000 and 999999 (inclusive)
    // nextInt(900000) gives 0-899999, +100000 gives 100000-999999
    return Random().nextInt(900000) + 100000;
  }

  // to string
  @override
  String toString() {
    return 'GroupModel{groupID: $groupID, adminId: $adminId, round: $round, usersID: $usersID, hatimRounds: $hatimRounds, startDate: $startDate, endDate: $endDate, plannedStartDate: $plannedStartDate, groupDateCount: $groupDateCount, userCount: $userCount, hatimStyle: $hatimStyle, status: $status, dateType: $dateType, calendarType: $calendarType, hijriStart: $hijriStartYear/$hijriStartMonth/$hijriStartDay, startTime: $startHour:$startMinute, createdDate: $createdDate}';
  }
}
