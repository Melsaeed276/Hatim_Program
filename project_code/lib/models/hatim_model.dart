import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:hatim_program/models/group_model.dart';

class HatimRoundModel {
  ///The roundID is a unique identifier for the hatim round. also
  ///It is used to calculate the start and end dates of the round.
  final int roundID;
  final List<String> completedUserIDs;

  HatimRoundModel({required this.roundID, List<String>? completedUserIDs})
      : completedUserIDs = completedUserIDs ?? [];

  /// Ensures the Juz number is always between 1 and 30
  static int giveChapterNumber(int value) {
    int result = value % 30;
    return result == 0 ? 30 : result;
  }

  /// Calculates the Juz number for a specific user in this round
  int getJuzForUser(String userId, List<String> groupUsers, HatimStyle style) {
    if (style == HatimStyle.byRounds) return giveChapterNumber(roundID);
    int index = groupUsers.indexOf(userId);
    if (index == -1) return 0;
    return giveChapterNumber(index + roundID);
  }

  /// Calculates the start date for this round based on group activation
  DateTime getStartDate(DateTime groupStartDate, GroupDateType dateType) {
    switch (dateType) {
      case GroupDateType.week:
        return groupStartDate.add(Duration(days: (roundID - 1) * 7));
      case GroupDateType.day:
        return groupStartDate.add(Duration(days: (roundID - 1)));
    }
  }

  /// Calculates the end date for this round based on group activation
  DateTime getEndDate(DateTime groupStartDate, GroupDateType dateType) {
    final start = getStartDate(groupStartDate, dateType);
    switch (dateType) {
      case GroupDateType.week:
        return start.add(const Duration(days: 7));
      case GroupDateType.day:
        return start.add(const Duration(days: 1));
    }
  }

  bool isHatimCompleted(String userID) => completedUserIDs.contains(userID);

  bool isAllUserCompleted(int totalUsers) =>
      completedUserIDs.length == totalUsers;

  int howManyUserCompleted() => completedUserIDs.length;

  /// To json (Lean Storage: only persist roundID and who is done)
  Map<String, dynamic> toJson() {
    try {
      final json = {'roundID': roundID, 'completedUserIDs': completedUserIDs};
      return json;
    } catch (e) {
      if (kDebugMode) {
        print('HATIM_MODEL ERROR in toJson(): $e');
        print('HATIM_MODEL: roundID = $roundID');
        print('HATIM_MODEL: completedUserIDs = $completedUserIDs');
      }
      rethrow;
    }
  }

  /// From json
  factory HatimRoundModel.fromJson(Map<String, dynamic> json) {
    return HatimRoundModel(
      roundID: json['roundID'],
      completedUserIDs: List<String>.from(json['completedUserIDs'] ?? []),
    );
  }

  //is equal
  bool isEqual(HatimRoundModel hatimRoundModel) {
    return hatimRoundModel.roundID == roundID &&
        hatimRoundModel.completedUserIDs.length == completedUserIDs.length &&
        hatimRoundModel.completedUserIDs.every(
          (id) => completedUserIDs.contains(id),
        );
  }

  //To string
  @override
  String toString() {
    return 'HatimRoundModel{roundID: $roundID, completedUserIDsCount: ${completedUserIDs.length}}';
  }
}
