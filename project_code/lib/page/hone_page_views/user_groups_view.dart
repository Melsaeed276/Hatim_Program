import 'package:flutter/material.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/page/hone_page_views/group_list.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import 'join_group_dialog.dart';

class UserGroupsView extends StatefulWidget {
  final UserModel userData;

  const UserGroupsView({super.key, required this.userData});

  @override
  State<UserGroupsView> createState() => _UserGroupsViewState();
}

class _UserGroupsViewState extends State<UserGroupsView> {
  late Future<List<GroupModel>> _groupsFuture;

  bool _didLoad = false;

  /// init state
  @override
  void initState() {
    super.initState();
    final userController = Provider.of<UserController>(context, listen: false);

    if (_didLoad == false) {
      _didLoad = true;
      // Admins now behave like normal users - they see only their joined groups
      _groupsFuture = userController.getAllGroupsOfUser();
    }
  }

  @override
  void didUpdateWidget(covariant UserGroupsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refresh if groups number changed or if they are different
    if (widget.userData.groups.length != oldWidget.userData.groups.length) {
      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );
      _groupsFuture = userController.getAllGroupsOfUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: false,
    ).getLanguage();

    //Theme
    final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme;
    // size of the screen
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      //Rounded top left and right
      decoration: BoxDecoration(
        color: themeColor.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // my groups
        children: [
          ///Group header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    lang.myGroups!,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),

                // join group button
                Expanded(
                  child: TextButton(
                    //style
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onPressed: () {
                      // All users (including admins) use the join group dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return JoinGroupDialog(userID: widget.userData.id);
                        },
                      ).then((_) {
                        setState(() {
                          final userController = Provider.of<UserController>(
                            context,
                            listen: false,
                          );
                          _groupsFuture = userController.getAllGroupsOfUser();
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        lang.joinGroup!,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall!.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///Groups list - always show the future builder
          /// The future builder will handle showing the "no groups" message if needed
          Expanded(
            /// if the user is not admin it will show only the groups but if admin it will show more data related to the group
            child: FutureBuilder<List<GroupModel>>(
              future: _groupsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  final lang = Provider.of<LocalizationController>(
                    context,
                    listen: false,
                  ).getLanguage();
                  return Text('${lang.errorPrefix!}${snapshot.error}');
                } else {
                  // Check if there are any groups
                  if (snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lang.youDoNotHaveGroupYet!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge!,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              lang.pleaseJoinAGroupYouNeedToPressOnJoinButton!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium!,
                            ),
                            const SizedBox(height: 20),
                            // join group button
                            TextButton(
                              //style
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.onPrimary,
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              onPressed: () {
                                //Navigator
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return JoinGroupDialog(
                                      userID: widget.userData.id,
                                    );
                                  },
                                ).then((_) {
                                  setState(() {
                                    final userController =
                                        Provider.of<UserController>(
                                          context,
                                          listen: false,
                                        );
                                    _groupsFuture = userController
                                        .getAllGroupsOfUser();
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  lang.joinGroup!,
                                  style: theme.textTheme.labelLarge!.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return GroupList(
                      groups: snapshot.data!,
                      userID: widget.userData.id,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
