import 'package:flutter/material.dart';

import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/page_route.dart';
import 'package:provider/provider.dart';

import '../controller/contollers.dart';
import 'hone_page_views/user_groups_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();
    final userController = Provider.of<UserController>(context, listen: true);

    //Theme
    final theme = Theme.of(context);

    // print(ModalRoute.of(context)!.settings.name);

    return FutureBuilder<UserModel?>(
      future: userController
          .getUserByPhoneNumber(), // Assuming this method loads the userController data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show a loading spinner while waiting
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error if any
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(lang.homePageTitle!),
              leading: const SizedBox(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    userController.setUserID = '0';
                    context
                        .read<AuthController>()
                        .phoneNumberController
                        .clear();
                    context.read<AuthController>().nameController.clear();

                    AppRoutes.goBack(context);
                  },
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, bottom: 5),
                  child: Text(
                    '${lang.welcome} ${userController.userModel?.name}',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 40.0, bottom: 18, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 4,
                          child: Text(
                              lang.youCanFollowYourHatimAndUpdateItFromHere!,
                              style: theme.textTheme.labelLarge)),
                    ],
                  ),
                ),
                Expanded(
                    child: UserGroupsView(
                  userData: userController.userModel!,
                )),
              ],
            ),
          );
        }
      },
    );
  }
}
