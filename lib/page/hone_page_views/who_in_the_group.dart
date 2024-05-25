import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hatim_program/models/models.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';

class WhoInTheGroup extends StatefulWidget {
  // get the userID as input
  final List<String> userIDs;

  const WhoInTheGroup({super.key, required this.userIDs});

  @override
  State<WhoInTheGroup> createState() => _WhoInTheGroupState();
}

class _WhoInTheGroupState extends State<WhoInTheGroup> {
  final ScrollController _scrollController = ScrollController();

  late final List<UserModel> userNameList;
  //future to get the available groups for the user
  late  final Future<List<UserModel>> _getUserNameList;
  @override
  void initState() {
    _getUserNameList = _loadUsers();
    super.initState();
  }


  Future<List<UserModel>> _loadUsers() async{
    final userController = Provider.of<UserController>(context, listen: false);
    for(String id in widget.userIDs){
      var user = await userController.loadUser(id: id);
      userNameList.add(user!);
    }
    return userNameList;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: false)
        .getLanguage();


    return AlertDialog(
      title: Text(lang.pleaseJoinAGroupYouNeedToPressOnJoinButton!,
          style: Theme.of(context).textTheme.titleMedium),
      content: FutureBuilder<List<UserModel>>(
        future: _getUserNameList,
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
                        for (var userModel in snapshot.data!)
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
                                          '${lang.userName!}: ${userModel.name}',
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                            'ID: ${userModel.id}',
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  ),

                                ],


                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );

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
