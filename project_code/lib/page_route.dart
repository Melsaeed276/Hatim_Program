import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/models/models.dart';
import 'package:hatim_program/page/hatim_page/hatim_details_page.dart';

import 'page/over_screens/over_screens.dart';
import 'page/pages.dart';
import 'page/admin/admin_config_page.dart';
import 'page/admin/group_members_page.dart';

/// in this file we will define all the routes of the application and manage the navigation of the application

class AppRoutes {
  static const home = 'home';
  static const login = '/';
  static const register = 'register';
  static const group = 'home/group';
  static const hatim = 'home/group/hatim';
  static const adminConfig = 'home/admin';
  static const groupMembers = 'home/admin/members';
  static const profile = 'home/profile';

  static String _location(String path) {
    if (!path.startsWith('/')) {
      return '/$path';
    } else {
      return path;
    }
  }

  static GoRouter? _cachedRouter;
  static String? _cachedRouterUserId;

  /// Returns a cached [GoRouter] instance for the given user id.
  ///
  /// The router is cached to prevent unnecessary recreation on rebuilds
  /// (like theme or locale changes). However, it will be recreated if the
  /// user ID changes (login/logout).
  static GoRouter router(String id) {
    // Only recreate router if user ID actually changed
    if (_cachedRouter != null && _cachedRouterUserId == id) {
      return _cachedRouter!;
    }

    _cachedRouterUserId = id;
    final String initRoute = id != '0' ? '/${AppRoutes.home}' : AppRoutes.login;

    _cachedRouter = GoRouter(
      initialLocation: initRoute,
      // Add error handling for better debugging
      errorBuilder: (context, state) {
        if (kDebugMode) {
          print('GoRouter Error: ${state.error}');
        }
        return Scaffold(
          body: Center(child: Text('Navigation Error: ${state.error}')),
        );
      },
      routes: <GoRoute>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>
              ApplyForEachPage(child: LoginPage()),
          routes: <GoRoute>[
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) =>
                  const ApplyForEachPage(child: HomePage()),
              routes: [
                GoRoute(
                  path: 'group',
                  builder: (context, state) =>
                      const ApplyForEachPage(child: HatimsPage()),
                  routes: [
                    GoRoute(
                      path: 'hatim',
                      builder: (context, state) {
                        final Map<String, dynamic> args =
                            state.extra as Map<String, dynamic>;
                        final hatimRound = args['hatim'] as HatimRoundModel?;
                        final group = args['group'] as GroupModel?;
                        return ApplyForEachPage(
                          child: HatimDetailsPage(
                            hatimRound: hatimRound,
                            group: group,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'admin',
                  builder: (context, state) =>
                      const ApplyForEachPage(child: AdminConfigPage()),
                  routes: [
                    GoRoute(
                      path: 'members',
                      builder: (context, state) {
                        final group = state.extra as GroupModel;
                        return ApplyForEachPage(
                          child: GroupMembersPage(group: group),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'profile',
                  builder: (context, state) =>
                      const ApplyForEachPage(child: ProfilePage()),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.register,
              builder: (context, state) =>
                  ApplyForEachPage(child: RegisterPage()),
            ),
          ],
        ),
      ],
    );

    return _cachedRouter!;
  }

  //static go to the home page
  static void goToHome(BuildContext context) {
    GoRouter.of(context).go(_location(AppRoutes.home));
  }

  //static go to the login page
  static void goToLogin(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.login);
  }

  //static go to the register page
  static void goToRegister(BuildContext context) {
    GoRouter.of(context).go(_location(AppRoutes.register));
  }

  //static go to the group page
  static void goToGroup(BuildContext context) {
    GoRouter.of(context).push(_location(AppRoutes.group));
  }

  //static go to the hatim page
  static void goToHatim(
    BuildContext context,
    HatimRoundModel hatim,
    GroupModel group,
  ) {
    GoRouter.of(
      context,
    ).push(_location(AppRoutes.hatim), extra: {'hatim': hatim, 'group': group});
  }

  //static go to the admin config page
  static void goToAdminConfig(BuildContext context) {
    GoRouter.of(context).push(_location(AppRoutes.adminConfig));
  }

  //static go to the profile page
  static void goToProfile(BuildContext context) {
    GoRouter.of(context).push(_location(AppRoutes.profile));
  }

  //static go to the group members page
  static void goToGroupMembers(BuildContext context, GroupModel group) {
    GoRouter.of(context).push(_location(groupMembers), extra: group);
  }

  //static go back
  static void goBack(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      if (router.canPop()) {
        router.pop();
        return;
      }

      // Fallback custom logic if canPop is false but we want to navigate up
      // We use a try-catch for GoRouterState as it might not be available in all contexts
      String? currentLocation;
      try {
        currentLocation = GoRouterState.of(context).uri.path;
      } catch (_) {
        // If no GoRouterState, we can't do our custom parent logic
      }

      if (currentLocation != null && currentLocation != '/') {
        final lastSlashIndex = currentLocation.lastIndexOf('/');
        if (lastSlashIndex > 0) {
          final parentLocation = currentLocation.substring(0, lastSlashIndex);
          router.go(_location(parentLocation));
        } else {
          router.go(AppRoutes.login);
        }
      } else {
        // Ultimate fallback
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in AppRoutes.goBack: $e');
      }
      // If everything else fails, try standard navigator pop
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }
}
