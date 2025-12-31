
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/models/hatim_model.dart';
import 'package:hatim_program/page/hatim_page/hatim_details_page.dart';
import 'package:hatim_program/page/profile_page.dart';
import 'package:hatim_program/page/community/communities_page.dart';
import 'package:hatim_program/page/admin_dashboard/admin_dashboard_page.dart';

import 'page/over_screens/over_screens.dart';
import 'page/pages.dart';


/// in this file we will define all the routes of the application and manage the navigation of the application

class AppRoutes {
  static const login = '/';
  static const register = '/register';
  static const home = '/home';
  static const group = '/group';
  static const hatim = '/hatim';
  static const profile = '/profile';
  static const communities = '/communities';
  static const admin = '/admin';


  static GoRouter router(String id){

    String initRoute = id != '0' ? AppRoutes.home : AppRoutes.login;


    return GoRouter(
      initialLocation: initRoute,

      routes: <GoRoute>[
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>  ApplyForEachPage(child: LoginPage()),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => ApplyForEachPage(child: RegisterPage()),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const ApplyForEachPage(child: HomePage()),
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
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ApplyForEachPage(child: ProfilePage()),
        ),
        GoRoute(
          path: AppRoutes.communities,
          builder: (context, state) => const ApplyForEachPage(child: CommunitiesPage()),
        ),
        GoRoute(
          path: AppRoutes.admin,
          builder: (context, state) => const ApplyForEachPage(child: AdminDashboardPage()),
        ),
      ],
    );
  }

  //static go to the home page
  static void goToHome(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.home);
  }

  //static go to the login page
  static void goToLogin(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.login);
  }

  //static go to the register page
  static void goToRegister(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.register);
  }

  //static go to the group page
  static void goToGroup(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.group);
  }

  //static go to the hatim page
  static void goToHatim(BuildContext context, HatimRoundModel hatim) {
    GoRouter.of(context).go(
      AppRoutes.hatim,
      extra: hatim, // Pass the HatimRoundModel object as extra
    );
  }

  //static go to the profile page
  static void goToProfile(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.profile);
  }

  //static go to the communities page
  static void goToCommunities(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.communities);
  }

  //static go to the admin page
  static void goToAdmin(BuildContext context) {
    GoRouter.of(context).go(AppRoutes.admin);
  }

  //static go back
  static void goBack(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    } else {
      // If can't pop, go to login page
      router.go(AppRoutes.login);
    }
  }
}
