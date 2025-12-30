import 'package:flutter/material.dart';

import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/page_route.dart';
import 'package:provider/provider.dart';

import '../controller/contollers.dart';
import '../localization/localization.dart';
import 'dialogs/admin_password_dialog.dart';
import 'dialogs/app_info_dialog.dart';
import 'dialogs/settings_dialog.dart';
import 'hone_page_views/user_groups_view.dart';
import 'over_screens/programs_coming_soon.dart';
import 'over_screens/zikir_coming_soon.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Future<UserModel?>? _userFuture;

  Future<void> _logout(BuildContext context) async {
    final userController = context.read<UserController>();
    userController.setUserID = '0';
    context.read<AuthController>().phoneNumberController.clear();
    context.read<AuthController>().nameController.clear();

    if (context.mounted) {
      AppRoutes.goToLogin(context);
    }
    userController.resetUser();
  }

  Future<void> _openSettingsSheet(BuildContext context) async {
    await SettingsDialog.show(
      context,
      onLogout: () => _logout(context),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the user fetch Future so changing tabs doesn't refetch/rebuild everything.
    _userFuture ??= Provider.of<UserController>(
      context,
      listen: false,
    ).getUserByPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final userController = Provider.of<UserController>(context, listen: true);

    //Theme
    final theme = Theme.of(context);

    return FutureBuilder<UserModel?>(
      future: _userFuture,
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
          final userModel = snapshot.data;
          final isAdmin = userModel?.isAdmin ?? false;

          if (userModel != null &&
              isAdmin &&
              userModel.adminPassword != null &&
              userModel.adminPassword!.isNotEmpty &&
              !userController.isAdminPasswordVerified) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              final passwordVerified = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AdminPasswordDialog(
                  storedPassword: userModel.adminPassword!,
                ),
              );

              if (passwordVerified == true) {
                userController.setAdminPasswordVerified = true;
              } else {
                userController.resetUser();
                if (context.mounted) {
                  AppRoutes.goToLogin(context);
                }
              }
            });
            return const Center(child: CircularProgressIndicator());
          }

          return PopScope(
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                title: _selectedIndex  == 0 ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${lang.welcome}: ', style: theme.textTheme.titleLarge!.copyWith(
                    
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    const SizedBox(width: 8),
                    Text(userModel?.name ?? '', 
                    style: theme.textTheme.titleLarge,),
                  ],
                ):Text(_getAppBarTitle(lang, userModel?.name)),
                automaticallyImplyLeading: false,
                actions: [
                if (_selectedIndex == 3)
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: lang.infoButtonTooltip ?? 'Info',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AppInfoDialog(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: lang.settings ?? 'Settings',
                  onPressed: () => _openSettingsSheet(context),
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                // Regular user view
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        bottom: 18,
                        top:
                            20, // Added top padding since we removed the previous header
                        right: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              lang.youCanFollowYourHatimAndUpdateItFromHere!,
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: UserGroupsView(
                        userData: userController.userModel!,
                      ),
                    ),
                  ],
                ),
                const ZikirComingSoon(),
                const ProgramsComingSoon(),
                const ProfileContent(),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.groups),
                  label: lang.hatimTab ?? 'Hatim',
                ),
                NavigationDestination(
                  icon: const Icon(Icons.auto_awesome),
                  label: lang.zikirTab ?? 'Zikir',
                ),
                NavigationDestination(
                  icon: const Icon(Icons.event_note),
                  label: lang.programsTab ?? 'Programs',
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person),
                  label: lang.profileTab ?? 'Profile',
                ),
              ],
            ),
            floatingActionButton: isAdmin
                ? FloatingActionButton.extended(
                    backgroundColor: theme.colorScheme.primary,
                    onPressed: () => AppRoutes.goToAdminConfig(context),
                    icon: Icon(
                      Icons.admin_panel_settings,
                      color: theme.colorScheme.onPrimary,
                    ),
                    label: Text(
                      lang.adminPanelText ?? 'Admin Panel',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : null,
            ),
          );
        }
      },
    );
  }

  String _getAppBarTitle(Localization lang, String? userName) {
    switch (_selectedIndex) {
      case 0:
        return '${lang.welcome} ${userName ?? ''}';
      case 1:
        return lang.zikirTab ?? 'Zikir';
      case 2:
        return lang.programsTab ?? 'Programs';
      case 3:
        return lang.profileTab ?? 'Profile';
      default:
        return lang.homePageTitle ?? 'Home';
    }
  }
}
