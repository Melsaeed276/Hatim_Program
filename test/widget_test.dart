// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.



import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/models/models.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    GroupModel groupModel = GroupModel(groupID: '1');

     // add users to the group



    for(int i = 0; i < 30; i++){
      groupModel.addUserToGroup(i.toString());
    }



    if (groupModel.hatimRounds.isNotEmpty){
      for(var hatim in groupModel.hatimRounds){
        // print only the date without the time

        print(hatim.roundID);
        print(hatim.startDate.toString().split(' ')[0]);
        print(hatim.endDate.toString().split(' ')[0]);
        print("");
      }
    }

  });
}

