import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import '../../localization/localization.dart';
import '../../page_route.dart';
import '../over_screens/programs_coming_soon.dart';
import '../over_screens/zikir_coming_soon.dart';
import 'admin_groups_management_view.dart';
import 'admin_users_view.dart';

class AdminConfigPage extends StatefulWidget {
  const AdminConfigPage({super.key});

  @override
  State<AdminConfigPage> createState() => _AdminConfigPageState();
}

class _AdminConfigPageState extends State<AdminConfigPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final userController = Provider.of<UserController>(context, listen: true);

    // Check if user is admin
    if (userController.userModel == null ||
        !userController.userModel!.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: Text(lang.adminPanelText ?? 'Admin Config'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => AppRoutes.goBack(context),
          ),
        ),
        body: Center(
          child: Text(lang.youAreNotAnAdmin ?? 'You are not an admin'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.goBack(context),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          AdminGroupsManagementView(),
          ZikirComingSoon(),
          ProgramsComingSoon(),
          AdminUsersView(),
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
            icon: const Icon(Icons.auto_stories),
            label: lang.myHatimProgramTab ?? 'My Hatim',
          ),
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome),
            label: lang.myZikirTab ?? 'My Zikir',
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note),
            label: lang.myProgramsTab ?? 'My Programs',
          ),
          NavigationDestination(
            icon: const Icon(Icons.people),
            label: lang.myUsersTab ?? 'My Users',
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(Localization lang) {
    switch (_selectedIndex) {
      case 0:
        return lang.myHatimProgramTab ?? 'My Hatim';
      case 1:
        return lang.myZikirTab ?? 'My Zikir';
      case 2:
        return lang.myProgramsTab ?? 'My Programs';
      case 3:
        return lang.myUsersTab ?? 'My Users';
      default:
        return lang.adminPanelText ?? 'Admin Panel';
    }
  }
}
