
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/models/hatim_model.dart';
import 'package:hatim_program/page/hatim_page/hatim_details_page.dart';

import 'page/over_screens/over_screens.dart';
import 'page/pages.dart';


/// in this file we will define all the routes of the application and manage the navigation of the application

class AppRoutes {
  static const home = 'home';
  static const login = '/';
  static const register = 'register';
  static const group = 'home/group';
  static const hatim = 'home/group/hatim';


  static String _location(String path) {
    if (!path.startsWith('/')) {
      return '/$path';
    } else {
      return path;
    }
  }


  static GoRouter router(String id){

    String initRoute = id != '0' ? '/${AppRoutes.home}' : AppRoutes.login;


    return GoRouter(
      initialLocation: initRoute,

      routes: <GoRoute>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>  ApplyForEachPage(child: LoginPage()),
          routes: <GoRoute>[
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const ApplyForEachPage(child: HomePage()),
            ),
            GoRoute(
              path: AppRoutes.register,
              builder: (context, state) => ApplyForEachPage(child: RegisterPage()),
            ),
            GoRoute(
              path: AppRoutes.group,
              builder: (context, state) => const ApplyForEachPage(child: HatimsPage()),
            ),
            GoRoute(
              path: AppRoutes.hatim,
              builder: (context, state) {
                final hatimRound = state.extra as HatimRoundModel?; // Retrieve from extra
                return ApplyForEachPage(child: HatimDetailsPage(hatimRound: hatimRound));
              },
            ),
          ],
        ),
      ],
    );
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
    GoRouter.of(context).go(_location(AppRoutes.group));
  }

  //static go to the hatim page
  static void goToHatim(BuildContext context, HatimRoundModel hatim) {
    GoRouter.of(context).go(
        _location(AppRoutes.hatim),
      extra: hatim, // Pass the HatimRoundModel object as extra
    );
  }

  //static go back
  static void goBack(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    if (router.canPop()) { // Check if there's a route to pop
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentLocation = GoRouterState.of(context).path!;

        final lastSlashIndex = currentLocation.lastIndexOf('/');

        if (lastSlashIndex > 0) { // Ensure we're not at the root already
          final parentLocation = _removeLastSlash(currentLocation);

          router.go(_location(parentLocation)); // Navigate to the parent route
        } else {
          router.go('/'); // If at root, go to home page
        }
      });
    }
  }

  static String _removeLastSlash(String path) {
    /// it will remove the last '/' and the test after it
    /// if the input is 'home/group', the output will be 'home'
    /// if the input is 'home/group/hatim', the output will be 'home/group'

    final lastSlashIndex = path.lastIndexOf('/');
    return path.substring(0, lastSlashIndex);

  }
}
