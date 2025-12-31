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
        } else if (snapshot.data == null) {
          // Handle case where user is not logged in or user data is not available
          return Scaffold(
            appBar: AppBar(
              title: Text(lang.homePageTitle!),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(lang.userNotFound ?? 'User not found'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      AppRoutes.goToLogin(context);
                    },
                    child: Text(lang.login ?? 'Login'),
                  ),
                ],
              ),
            ),
          );
        } else {
          final user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(lang.homePageTitle!),
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


                    if (context.mounted) {
                      AppRoutes.goBack(context);
                    }
                    userController.resetUser();
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Menu'),
                  ),
                  ListTile(
                    title: const Text('Profile'),
                    onTap: () {
                      AppRoutes.goToProfile(context);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  ListTile(
                    title: const Text('Communities'),
                    onTap: () {
                      AppRoutes.goToCommunities(context);
                      Navigator.pop(context); // Close drawer
                    },
                  ),
                  if (user.isSuperAdmin)
                    ListTile(
                      title: const Text('Admin Dashboard'),
                      onTap: () {
                        AppRoutes.goToAdmin(context);
                        Navigator.pop(context); // Close drawer
                      },
                    ),
                ],
              ),
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
                  userData: user,
                )),
              ],
            ),
          );
        }
      },
    );
  }
}
