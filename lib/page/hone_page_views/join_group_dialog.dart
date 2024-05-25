import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hatim_program/models/group_model.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../over_screens/progress_indicator.dart';

class JoinGroupDialog extends StatefulWidget {
  // get the userID as input
  final String userID;

  const JoinGroupDialog({super.key, required this.userID});

  @override
  State<JoinGroupDialog> createState() => _JoinGroupDialogState();
}

class _JoinGroupDialogState extends State<JoinGroupDialog> {
  final ScrollController _scrollController = ScrollController();

  //future to get the available groups for the user
  late  final Future<List<GroupModel>> _getAllAvailableGroupsForUser;
  @override
  void initState() {
    // TODO: implement initState
    final groupController = Provider.of<GroupController>(context, listen: false);
    _getAllAvailableGroupsForUser = groupController.getAvailableGroupsForUser(userID: widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: false)
        .getLanguage();


    return AlertDialog(
      title: Text(lang.pleaseJoinAGroupYouNeedToPressOnJoinButton!,
          style: Theme.of(context).textTheme.titleMedium),
      content: FutureBuilder<List<GroupModel>>(
        future: _getAllAvailableGroupsForUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return Center(
              child: Text(
                lang.somethingWentWrong!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          } else if (snapshot.hasData) {
            // if has groups
            if (snapshot.data!.isNotEmpty) {
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var groupData in snapshot.data!)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${lang.groupName!}: ${groupData.groupID}',
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                            lang.thereIsStillXPlaceInTheGroupToStart!(
                                              count: groupData
                                                  .getHowMuchLeftPlaceInTheGroup(),
                                            ),
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      context
                                          .read<UserController>()
                                          .addUserGroup(groupData.groupID);
                                      Navigator.of(context).pop();
                                    },
                                    child: ProgressIndicatorWithNumber(
                                      currentValue: groupData
                                          .getHowMuchLeftPlaceInTheGroup(),
                                      icon: Icons.person_add_outlined,
                                      textData: lang.join!,
                                    ),
                                  ),
                                ],

                                // TextButton(
                                //   onPressed: () {
                                //     context.read<UserController>().addUserGroup(groupData.groupID);
                                //     Navigator.of(context).pop();
                                //   },
                                //   child: Text(lang.join!),
                                // ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
              // return ListView.builder(
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, index) {
              //     var groupData = snapshot.data![index];
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //       child: Card(
              //         child: Material(
              //           color: Colors.transparent,
              //           child: ListTile(
              //             title: Text(groupData.groupID),
              //             subtitle: Text(lang.thereIsStillXPlaceInTheGroupToStart!(count: groupData.getHowMuchLeftPlaceInTheGroup(),)),
              //             trailing: TextButton(
              //               onPressed: () {
              //                 context.read<UserController>().addUserGroup(groupData.groupID);
              //                 Navigator.of(context).pop();
              //               },
              //               child: Text(lang.join!),
              //             ),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  lang.thereIsNoAvailableGroupsForYouToJoinRightNowYouNeedToTalkToTheAdminToAddNewGroup!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            }
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
              bottom: 12.0, right: 12, left: 12.0, top: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(lang.close!),
            ),
          ),
        ),
      ],
    );

  }
}
