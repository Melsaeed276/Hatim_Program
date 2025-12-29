import 'package:flutter/material.dart';

import 'package:hatim_program/controller/auth_controller.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/page_route.dart';
import 'package:provider/provider.dart';

import '../controller/contollers.dart';
import 'dialogs/admin_password_dialog.dart';
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
          final lang = Provider.of<LocalizationController>(context, listen: false).getLanguage();
          return Text('${lang.errorPrefix!}${snapshot.error}'); // Show error if any
        } else {
          // Check if admin password verification is required
          final userModel = snapshot.data;
          if (userModel != null && 
              userModel.isAdmin && 
              userModel.adminPassword != null && 
              userModel.adminPassword!.isNotEmpty &&
              !userController.isAdminPasswordVerified) {
            // Admin user but password not verified - show password dialog
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final passwordVerified = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AdminPasswordDialog(
                  storedPassword: userModel.adminPassword!,
                ),
              );

              if (passwordVerified == true) {
                // Password verified, set flag
                userController.setAdminPasswordVerified = true;
              } else {
                // Password verification failed or cancelled, redirect to login
                userController.resetUser();
                if (context.mounted) {
                  AppRoutes.goToLogin(context);
                }
              }
            });
            return const Center(child: CircularProgressIndicator());
          }
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


                    if (context.mounted) {
                      AppRoutes.goBack(context);
                    }
                    userController.resetUser();
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
