import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/models/models.dart';
import 'package:provider/provider.dart';

import 'controller/contollers.dart';
import 'page/over_screens/over_screens.dart';
import 'page/pages.dart';
import 'page/admin/admin_config_page.dart';
import 'page/admin/group_members_page.dart';
import 'page/admin/admin_group_details_page.dart';

/// in this file we will define all the routes of the application and manage the navigation of the application

class AppRoutes {
  static const home = 'home';
  static const login = '/';
  static const register = 'register';
  static const profile = 'home/profile';
  static const adminConfig = 'home/admin';
  
  // Path-based routes with parameters
  static String hatimWithGroup(String groupID) => 'home/hatim/$groupID';
  static String adminHatimDetails(String groupID) => 'home/admin/hatim/$groupID/details';
  static String adminHatimMembers(String groupID) => 'home/admin/hatim/$groupID/members';

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
                // New path-based route: /home/hatim/:groupID
                GoRoute(
                  path: 'hatim/:groupID',
                  builder: (context, state) {
                    final groupID = state.pathParameters['groupID'];
                    if (groupID == null) {
                      return const Scaffold(
                        body: Center(child: Text('Invalid group ID')),
                      );
                    }
                    return ApplyForEachPage(child: HatimsPage(groupID: groupID));
                  },
                ),
                // Admin routes with protection
                GoRoute(
                  path: 'admin',
                  redirect: (context, state) {
                    final userController = Provider.of<UserController>(context, listen: false);
                    final isAdmin = userController.userModel?.isAdmin ?? false;
                    if (!isAdmin) {
                      return '/home';
                    }
                    return null;
                  },
                  builder: (context, state) =>
                      const ApplyForEachPage(child: AdminConfigPage()),
                  routes: [
                    // Admin hatim routes with groupID parameter
                    GoRoute(
                      path: 'hatim/:groupID/members',
                      redirect: (context, state) {
                        final userController = Provider.of<UserController>(context, listen: false);
                        final isAdmin = userController.userModel?.isAdmin ?? false;
                        if (!isAdmin) {
                          return '/home';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final groupID = state.pathParameters['groupID'];
                        if (groupID == null) {
                          return const Scaffold(
                            body: Center(child: Text('Invalid group ID')),
                          );
                        }
                        
                        // Fetch group data
                        final groupController = Provider.of<GroupController>(context, listen: false);
                        return FutureBuilder<GroupModel?>(
                          future: groupController.getGroupByID(groupID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Scaffold(
                                body: Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return Scaffold(
                                body: Center(child: Text('Error: ${snapshot.error}')),
                              );
                            } else if (snapshot.data == null) {
                              return const Scaffold(
                                body: Center(child: Text('Group not found')),
                              );
                            }
                            return ApplyForEachPage(
                              child: GroupMembersPage(group: snapshot.data!),
                            );
                          },
                        );
                      },
                    ),
                    GoRoute(
                      path: 'hatim/:groupID/details',
                      redirect: (context, state) {
                        final userController = Provider.of<UserController>(context, listen: false);
                        final isAdmin = userController.userModel?.isAdmin ?? false;
                        if (!isAdmin) {
                          return '/home';
                        }
                        return null;
                      },
                      builder: (context, state) {
                        final groupID = state.pathParameters['groupID'];
                        if (groupID == null) {
                          return const Scaffold(
                            body: Center(child: Text('Invalid group ID')),
                          );
                        }
                        
                        // Fetch group data
                        final groupController = Provider.of<GroupController>(context, listen: false);
                        return FutureBuilder<GroupModel?>(
                          future: groupController.getGroupByID(groupID),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Scaffold(
                                body: Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError) {
                              return Scaffold(
                                body: Center(child: Text('Error: ${snapshot.error}')),
                              );
                            } else if (snapshot.data == null) {
                              return const Scaffold(
                                body: Center(child: Text('Group not found')),
                              );
                            }
                            return ApplyForEachPage(
                              child: AdminGroupDetailsPage(group: snapshot.data!),
                            );
                          },
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

  //static go to the hatim page with groupID
  static void goToHatim(BuildContext context, String groupID) {
    GoRouter.of(context).push(_location(AppRoutes.hatimWithGroup(groupID)));
  }

  //static go to the admin config page
  static void goToAdminConfig(BuildContext context) {
    GoRouter.of(context).push(_location(AppRoutes.adminConfig));
  }

  //static go to the profile page
  static void goToProfile(BuildContext context) {
    GoRouter.of(context).push(_location(AppRoutes.profile));
  }

  //static go to the group members page (admin)
  static void goToGroupMembers(BuildContext context, String groupID) {
    GoRouter.of(context).push(_location(AppRoutes.adminHatimMembers(groupID)));
  }

  //static go to the admin group details page
  static void goToAdminGroupDetails(BuildContext context, String groupID) {
    GoRouter.of(context).push(_location(AppRoutes.adminHatimDetails(groupID)));
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
