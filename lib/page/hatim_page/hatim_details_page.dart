import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../models/models.dart';
import '../../page_route.dart';

class HatimDetailsPage extends StatefulWidget {
  final HatimRoundModel? hatimRound;

  const HatimDetailsPage({super.key, required this.hatimRound});

  @override
  State<HatimDetailsPage> createState() => _HatimDetailsPageState();
}

class _HatimDetailsPageState extends State<HatimDetailsPage> {

  late Future<Map<String, UserModel?>> userMapFuture;

  @override
  void initState() {
    super.initState();
    userMapFuture = _loadUserMap();
  }

  Future<Map<String, UserModel?>> _loadUserMap() async {
    final userController = Provider.of<UserController>(context, listen: false);
    Map<String, UserModel?> userMap = {};

    if (widget.hatimRound != null) {
      for (final userID in widget.hatimRound!.userList) {
        userMap[userID] = await userController.loadUser(id: userID);
      }
    }

    return userMap;
  }

  @override
  Widget build(BuildContext context) {
    // ... (your existing code)

    if (widget.hatimRound == null) {
      return _buildErrorScreen(context);
    } else {
      return _buildHatimDetails(context);
    }
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('Error: Hatim Round is null'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //  Navigator.popAndPushNamed(context, AppRoutes.group);

                AppRoutes.goToGroup(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHatimDetails(BuildContext context) {

  final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme;

  final lang = Provider.of<LocalizationController>(context, listen: true)
      .getLanguage();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Hatim Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              AppRoutes.goToGroup(context);
            },
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${lang.hatim}: ${widget.hatimRound!.roundID}',
              style: theme.textTheme.headlineMedium,
            ),
          ),
        FutureBuilder<Map<String, UserModel?>>(
        future: userMapFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user data: ${snapshot.error}'));
          } else {
            final userMap = snapshot.data!; // User data is now available
            return Expanded(
              child: ListView.builder(
                itemCount: widget.hatimRound!.userList.length,
                itemBuilder: (context, index) {
                  final userID = widget.hatimRound!.sortByWhoCompletedHatim()[index];
                  final userName = userMap[userID]?.name ?? 'Unknown';

                  bool isHatimCompleted =
                  widget.hatimRound!.isHatimCompleted(userID);


                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0),
                    child: Card(
                      color: isHatimCompleted
                          ? themeColor.primaryContainer.withOpacity(0.7)
                          : themeColor.errorContainer.withOpacity(0.6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: themeColor.surfaceContainer,
                            // if the user is completed the hatim, show a green circle, otherwise show a red circle
                            child: isHatimCompleted
                                ? const Icon(Icons.check,
                                color: Colors.green)
                                : const Icon(Icons.close,
                                color: Colors.red),
                          ),
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${lang.userName}: $userName',
                                  style: theme.textTheme.titleMedium,
                                ),
                                TextSpan(
                                  text: '\t ID:${widget.hatimRound!.userList[index]}',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: themeColor.onSurface
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${lang.hatimChapterNumber}:\t',
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(
                                      color: themeColor.onSurface.withOpacity(0.5)).copyWith(
                                      color:isHatimCompleted
                                          ? themeColor.onSurface
                                          : themeColor.onErrorContainer.withOpacity(0.6)
                                  ),
                                ),

                                TextSpan(
                                  text:
                                  '${widget.hatimRound!.getCurrentHatimChapterOfUser(userID)}',
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                      color:isHatimCompleted
                                          ? themeColor.primary
                                          : themeColor.error),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  // ... (rest of your ListTile code)
                },
              ),
            );
          }
        },
      ),
        ],
      ),
    );
  }

// ... (rest of your code)
}

  // @override
  // Widget build(BuildContext context) {
  //   final lang = Provider.of<LocalizationController>(context, listen: true)
  //       .getLanguage();
  //
  //   final userController = Provider.of<UserController>(context, listen: false);
  //
  //   final theme = Theme.of(context);
  //   final themeColor = Theme.of(context).colorScheme;
  //
  //   if (widget.hatimRound == null) {
  //     // pop back
  //     return Scaffold(
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.max,
  //           children: [
  //             const Text('Error: Hatim Round is null'),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               onPressed: () {
  //                 //  Navigator.popAndPushNamed(context, AppRoutes.group);
  //
  //                 AppRoutes.goToGroup(context);
  //               },
  //               child: const Text('Back'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Scaffold(
  //       appBar: AppBar(
  //           title: const Text('Hatim Details'),
  //           leading: IconButton(
  //             icon: const Icon(Icons.arrow_back),
  //             onPressed: () {
  //               AppRoutes.goToGroup(context);
  //             },
  //           )),
  //       body: Column(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(12.0),
  //             child: Text(
  //               '${lang.hatim}: ${widget.hatimRound!.roundID}',
  //               style: theme.textTheme.headlineMedium,
  //             ),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: widget.hatimRound!.userList.length,
  //               itemBuilder: (context, index) {
  //                 final userID = widget.hatimRound!.sortByWhoCompletedHatim()[index];
  //                 final userName =
  //                     userController.getUserByPhoneNumber(id: userID);
  //
  //                 return FutureBuilder<UserModel?>(
  //                   future: userController.getUserByPhoneNumber(id: userID),
  //                   builder: (context, snapshot) {
  //                     if (snapshot.connectionState == ConnectionState.waiting) {
  //                       return const Center(
  //                           child:
  //                               CircularProgressIndicator()); // Show loading indicator while waiting for the future to complete
  //                     } else if (snapshot.hasError) {
  //                       return Text(
  //                           'Error: ${snapshot.error}'); // Show error message if the future completes with an error
  //                     } else {
  //                       final userName = snapshot.data?.name ??
  //                           'Unknown'; // Get the user's name if the future completes successfully
  //
  //                       bool isHatimCompleted =
  //                           widget.hatimRound!.isHatimCompleted(userID);
  //
  //
  //                       return Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0),
  //                         child: Card(
  //                           color: isHatimCompleted
  //                               ? themeColor.surface
  //                             : themeColor.errorContainer.withOpacity(0.6),
  //                           child: Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: ListTile(
  //                               leading: CircleAvatar(
  //                                 backgroundColor: themeColor.background,
  //                                 // if the user is completed the hatim, show a green circle, otherwise show a red circle
  //                                 child: isHatimCompleted
  //                                     ? const Icon(Icons.check,
  //                                         color: Colors.green)
  //                                     : const Icon(Icons.close,
  //                                         color: Colors.red),
  //                               ),
  //                               title: Expanded(
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                       children: [
  //                                     TextSpan(
  //                                       text: '${lang.userName}: $userName',
  //                                       style: theme.textTheme.titleMedium,
  //                                     ),
  //                                         TextSpan(
  //                                           text: '\t ID:${widget.hatimRound!.userList[index]}',
  //                                           style: theme.textTheme.bodyMedium!.copyWith(
  //                                               color: themeColor.onBackground
  //                                                   .withOpacity(0.5)),
  //                                         ),
  //                                       ],
  //                                   ),
  //                                 ),
  //
  //
  //                               ),
  //                               subtitle: Expanded(
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                     children: [
  //                                       TextSpan(
  //                                         text: '${lang.hatimChapterNumber}:\t',
  //                                         style: theme.textTheme.bodyMedium!
  //                                             .copyWith(
  //                                                 color: themeColor.onBackground.withOpacity(0.5)).copyWith(
  //                                             color:isHatimCompleted
  //                                                 ? themeColor.onSurface
  //                                                 : themeColor.onErrorContainer.withOpacity(0.6)
  //                                         ),
  //                                       ),
  //
  //                                       TextSpan(
  //                                         text:
  //                                             '${widget.hatimRound!.getCurrentHatimChapterOfUser(userID)}',
  //                                         style: theme.textTheme.titleMedium!
  //                                             .copyWith(
  //                                                 color:isHatimCompleted
  //                                                     ? themeColor.primary
  //                                                     : themeColor.error),
  //                                       ),
  //                                       // TextSpan(
  //                                       //   text:
  //                                       //   hatimRound!.isHatimCompleted(userID)
  //                                       //       ? '${lang.thisHatimIsCompleted}'
  //                                       //       : '${lang.thisHatimIsNotCompleted}',
  //                                       //   style: theme.textTheme.titleMedium!
  //                                       //       .copyWith(
  //                                       //       color: hatimRound!
  //                                       //           .isHatimCompleted(userID)
  //                                       //           ? themeColor.primary
  //                                       //           : themeColor.error),
  //                                       // ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     }
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }
//}
