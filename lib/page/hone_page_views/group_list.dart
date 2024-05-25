import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../over_screens/progress_indicator.dart';
import '../../page_route.dart';
import 'who_in_the_group.dart';

class GroupList extends StatelessWidget {
  final List<GroupModel> groups;
  final String userID;

  const GroupList({super.key, required this.groups, required this.userID});

  @override
  Widget build(BuildContext context) {
    final lang = LocalizationController().getLanguage();
    final languageController = LocalizationController();

    final userController = Provider.of<UserController>(context, listen: false);
    final isAdmin = userController.userModel!.isAdmin;

    final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        // final groupValue = snapshot.data![index].round;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: GestureDetector(
            onTap: () async {

              if (group.usersID.length < 30){
                if(isAdmin){
                  //show Dialog of the users
                  // input the user list
                  showDialog(
                    context: context,
                    builder: (context) {
                      return WhoInTheGroup(userIDs: group.usersID,);
                    },
                  );

                }else {
                  // show Snackbar show the user text
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(lang.theGroupIsNotActiveYetPleaseWaitUntilTheAppMembersJoin!),
                    duration: const Duration(seconds: 2),
                  ),
                );
                }
                return;
              }else if (group.status == GroupStatus.active){
                ///Navigator my Id to the hatim page of that group and send hatim model
                ///Navigator.of(context).pushNamed('/group', arguments: group.hatimRounds);
                // navigate to the hatim page
                context.read<GroupController>().setGroupID = group.groupID;
                AppRoutes.goToGroup(context);
              }

              // List<HatimRoundModel>? data = await context.read<GroupController>().getUserHatimsRound(userID: userID,groupID: group.groupID);
              //print("object ${snapshot.data![index].getUserHatimsRound(userID)!.length}");
              //Navigator my Id to the hatim page of that group and send hatim model
              //Navigator.of(context).pushNamed('/group', arguments: data);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 18,),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${lang.groupName!}: ${group.groupID}',
                              style: theme.textTheme.titleMedium
                          ),
                          Text(
                            languageController.groupSubtitleText(
                                isGroupActive: group.status == GroupStatus.active,
                                number:isAdmin ? group.getCurrentHatim() : group.getCurrentHatimOfUser(userID)),

                            maxLines: 3,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: group.status == GroupStatus.active
                                  ? themeColor.primary
                                  : themeColor.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ProgressIndicatorWithNumber(
                          icon: group.status == GroupStatus.waiting
                              ? isAdmin
                              ? Icons.access_time_rounded : null
                              : null,
                          currentValue: group.status == GroupStatus.waiting
                              ? isAdmin? group.usersID.length : 0
                              : isAdmin
                                  ? group.getCurrentHatim()
                                  : group.getCurrentHatimOfUser(userID),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
