// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';

void main() {


  testWidgets('Group with custom weeks', (WidgetTester tester) async {

    GroupModel groupModel = GroupModel.withCustomWeeks(groupID: '9',groupDays: 15);

    // add users to the group
    //add 30 person to the group so it will start
    for(int i = 0; i < 15; i++){
      groupModel.addUserToGroup(i.toString());
    }




   // print(groupModel.hatimRounds.length);
  for(int i = 0; i < 15; i++){
    groupModel.hatimRounds[i].updateHatim(i.toString());
  }


    print(groupModel.hatimRounds.toString());

  });

}

