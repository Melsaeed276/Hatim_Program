import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../overlays/over_screens/programs_coming_soon.dart';
import '../../features/auth/pages/profile_page.dart';
import '../controllers/controllers.dart';
import 'package:provider/provider.dart';
import '../routing/page_route.dart';
import '../overlays/settings_button.dart';

class HomeHubPage extends StatefulWidget {
  const HomeHubPage({super.key});

  @override
  State<HomeHubPage> createState() => _HomeHubPageState();
}

class _HomeHubPageState extends State<HomeHubPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocalizationController>().getLanguage();

    final pages = const [
      ProgramsComingSoon(),
      ProfileContent(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.homePageTitle ?? 'Main Menu'),
        actions: const [
          SettingsButton(),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: Text(lang.communitiesTitle ?? 'Communities'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/${AppRoutes.communities}');
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.event_note),
            label: lang.programsTab ?? 'Programs',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            label: lang.account ?? 'Account',
          ),
        ],
      ),
    );
  }
}

