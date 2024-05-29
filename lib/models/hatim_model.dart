import 'dart:collection';
import 'dart:core';

class HatimRoundModel {
  final int roundID;

  final List<String> userList;

  Map<String, int> userHatim = {};

  Map<String, bool> userHatimCompleted = {};

  ///Start date of the hatim round
  ///it will be assigned when the round is created by multiple the roundID
  late DateTime startDate;

  ///end date of the hatim round
  ///it will be assigned  as 1 week from the start date of the round
late DateTime endDate;


  HatimRoundModel({required this.roundID, required this.userList}) {
    ///The Duration class in Dart does not have a named parameter weeks. Instead, you can calculate the number of days in a week and use the days parameter. There are 7 days in a week, so you can multiply the roundID - 1 by 7 to get the equivalent number of days.

    String dateString = "2024-04-25";
    DateTime dateTime = DateTime.parse(dateString);

    startDate = dateTime.add(Duration(days: (roundID - 1) * 7));

    ///The endDate is calculated by adding 7 days to the startDate.
    endDate = startDate.add(const Duration(days: 7));

    ///
    _assignHatim();
  }


  HatimRoundModel.withStartDateTime({required this.roundID, required this.userList,required this.startDate,}){
    ///The Duration class in Dart does not have a named parameter weeks. Instead, you can calculate the number of days in a week and use the days parameter. There are 7 days in a week, so you can multiply the roundID - 1 by 7 to get the equivalent number of days.
    startDate = DateTime.now().add(Duration(days: (roundID - 1) * 7));

    ///The endDate is calculated by adding 7 days to the startDate.
    endDate = startDate.add(const Duration(days: 7));

    ///
    _assignHatim();
  }

  void _assignHatim() {
    for (var element in userList) {
      int index = userList.indexOf(element);
      userHatim[element] = giveChapterNumber(index + roundID);
      userHatimCompleted[element] = false;
    }
  }

  // update
  void updateHatim(String userID) {
    if (userHatimCompleted[userID] == false) {
      userHatimCompleted[userID] = true;
    }
  }

  // get user data map<hatimID,isCompleted > of that user
  Map<String, bool> userHatimData(String userID) {
    return {userHatim[userID].toString(): userHatimCompleted[userID]!};
  }


  //get the current hatim chapter of the user
  int getCurrentHatimChapterOfUser(String userID) {
    return userHatim[userID]?? 0;
  }

  //sort the userHatim by who completed the hatim it will return List<String> of userID
  List<String> sortByWhoCompletedHatim() {
    List<String> userList = [];

    var competed =  userHatimCompleted.keys.where((element) => userHatimCompleted[element] == true).toList();

    var notCompeted =  userHatimCompleted.keys.where((element) => userHatimCompleted[element] == false).toList();

    userList.addAll(competed);
    userList.addAll(notCompeted);

    return userList;
  }



  //did all users complete the hatim
  bool isAllUserCompleted() {
    return userHatimCompleted.values.every((element) => element == true);
  }

  //how many users completed the hatim
  int howManyUserCompleted() {
    return userHatimCompleted.values.where((element) => element == true).length;
  }

  //did user complete the hatim
  bool isHatimCompleted(String userID) {
    return userHatimCompleted[userID]?? false;
  }

  int giveChapterNumber(int index) {
    if (index > 30) {
      return index - 30;
    } else {
      return index;
    }
  }

  ///To json
  Map<String, dynamic> toJson() {
    return {
      'roundID': roundID,
      'userList': userList,
      'userHatim': userHatim,
      'userHatimCompleted': userHatimCompleted,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  ///From json
  factory HatimRoundModel.fromJson(Map<String, dynamic> json) {
    return HatimRoundModel(
      roundID: json['roundID'],
      userList: List<String>.from(json['userList']),
    )..userHatim = LinkedHashMap<String, int>.from(json['userHatim'])
      ..userHatimCompleted = LinkedHashMap<String, bool>.from(json['userHatimCompleted'])
      ..startDate = DateTime.parse(json['startDate'])
      ..endDate = DateTime.parse(json['endDate']);
  }

  //is equal
  //check all the filed of the object if it is equal
  bool isEqual(HatimRoundModel hatimRoundModel) {
    return hatimRoundModel.roundID == roundID &&
        hatimRoundModel.userList == userList &&
        hatimRoundModel.userHatim == userHatim &&
        hatimRoundModel.userHatimCompleted == userHatimCompleted &&
        hatimRoundModel.startDate == startDate &&
        hatimRoundModel.endDate == endDate;
  }

}


