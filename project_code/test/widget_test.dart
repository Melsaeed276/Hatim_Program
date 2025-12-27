// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';

void main() {

  //
  // testWidgets('Group with diffrent user counts', (WidgetTester tester) async {
  //
  //   GroupModel groupWith30 = GroupModel.withCustomInfo(groupID: '9',userCount: 30);
  //   GroupModel groupWith20 = GroupModel.withCustomInfo(groupID: '9',userCount: 20);
  //   GroupModel groupWith10 = GroupModel.withCustomInfo(groupID: '9',userCount: 10);
  //   GroupModel groupWith5 = GroupModel.withCustomInfo(groupID: '9',userCount: 5);
  //   GroupModel groupWith2 = GroupModel.withCustomInfo(groupID: '9',userCount: 2);
  //   GroupModel groupWith1 = GroupModel.withCustomInfo(groupID: '9',userCount: 1);
  //
  //   // add users to the group
  //   //add 30 person to the group so it will start
  //   for(int i = 0; i < 1; i++){
  //     groupWith1.addUserToGroup(i.toString());
  //   }
  //
  // // asign users for each group
  //   for(int i = 0; i < 30; i++){
  //     groupWith30.addUserToGroup(i.toString());
  //   }
  //
  //   for(int i = 0; i < 20; i++){
  //     groupWith20.addUserToGroup(i.toString());
  //   }
  //
  //   for(int i = 0; i < 10; i++){
  //     groupWith10.addUserToGroup(i.toString());
  //   }
  //
  //   for(int i = 0; i < 5; i++){
  //     groupWith5.addUserToGroup(i.toString());
  //   }
  //
  //   for(int i = 0; i < 2; i++){
  //     groupWith2.addUserToGroup(i.toString());
  //   }
  //
  //
  //
  //   print(groupWith1.hatimRounds.toString());
  //
  //
  // });


  testWidgets('Group with day counts', (WidgetTester tester) async {

    GroupModel groupWith30 = GroupModel.withCustomInfo(groupID: '9',userCount: 30,dateType: GroupDateType.day);
    GroupModel groupWith20 = GroupModel.withCustomInfo(groupID: '9',userCount: 20,dateType: GroupDateType.day);
    GroupModel groupWith10 = GroupModel.withCustomInfo(groupID: '9',userCount: 10,dateType: GroupDateType.day);
    GroupModel groupWith5 = GroupModel.withCustomInfo(groupID: '9',userCount: 5,dateType: GroupDateType.day);
    GroupModel groupWith2 = GroupModel.withCustomInfo(groupID: '9',userCount: 2,dateType: GroupDateType.day);
    GroupModel groupWith1 = GroupModel.withCustomInfo(groupID: '9',userCount: 1,dateType: GroupDateType.day);

    // add users to the group
    //add 30 person to the group so it will start
    for(int i = 0; i < 1; i++){
      groupWith1.addUserToGroup(i.toString());
    }

    // asign users for each group
    for(int i = 0; i < 30; i++){
      groupWith30.addUserToGroup(i.toString());
    }

    for(int i = 0; i < 20; i++){
      groupWith20.addUserToGroup(i.toString());
    }

    for(int i = 0; i < 10; i++){
      groupWith10.addUserToGroup(i.toString());
    }

    for(int i = 0; i < 5; i++){
      groupWith5.addUserToGroup(i.toString());
    }

    for(int i = 0; i < 2; i++){
      groupWith2.addUserToGroup(i.toString());
    }



    if (kDebugMode) {
      print(groupWith1.hatimRounds.toString());
    }


  });


  // test only 2 users
  testWidgets('2 users making hatim', (WidgetTester tester) async {

    GroupModel groupWith2 = GroupModel.withCustomInfo(groupID: '2',userCount: 1,dateType: GroupDateType.day,hatimStyle: HatimStyle.byRounds);

    // add users to the group
    //add 30 person to the group so it will start
    for(int i = 0; i < 1; i++){
      groupWith2.addUserToGroup(i.toString());
    }

    if (kDebugMode) {
      print(groupWith2.hatimRounds.toString());
    }});

}

