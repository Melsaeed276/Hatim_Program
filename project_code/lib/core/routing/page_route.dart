import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/pages.dart';
import '../../features/community/pages/communities_page.dart';
import '../../features/community/pages/community_detail_page.dart';
import '../../features/community/pages/super_admin_panel_page.dart';
import '../pages/home_hub_page.dart';
import '../overlays/overlays.dart';

/// in this file we will define all the routes of the application and manage the navigation of the application

class AppRoutes {
  static const home = 'home';
  static const login = '/';
  static const register = 'register';
  static const communities = 'communities';
  static const communityDetail = 'community';
  static const superAdmin = 'super-admin';

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
    final bool isAuthenticated = id != '0';
    final String initRoute = isAuthenticated ? '/${AppRoutes.home}' : AppRoutes.login;

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
      // Global redirect: prevent authenticated users from accessing auth pages
      redirect: (BuildContext context, GoRouterState state) {
        final isAuthenticated = id != '0';
        final isAuthRoute = state.matchedLocation == AppRoutes.login || 
                           state.matchedLocation == '/${AppRoutes.register}';
        
        // If authenticated and trying to access login/register, redirect to home
        if (isAuthenticated && isAuthRoute) {
          return '/${AppRoutes.home}';
        }
        
        // If not authenticated and trying to access protected routes, redirect to login
        if (!isAuthenticated && !isAuthRoute) {
          return AppRoutes.login;
        }
        
        return null; // No redirect needed
      },
      routes: <GoRoute>[
        // Authentication routes (login, register) - separate from protected routes
        GoRoute(
          path: AppRoutes.login,
          builder: (BuildContext context, GoRouterState state) =>
              ApplyForEachPage(child: LoginPage()),
        ),
        GoRoute(
          path: '/${AppRoutes.register}',
          builder: (BuildContext context, GoRouterState state) =>
              ApplyForEachPage(child: RegisterPage()),
        ),
        // Protected routes - require authentication
        GoRoute(
          path: '/${AppRoutes.home}',
          builder: (context, state) =>
              const ApplyForEachPage(child: HomeHubPage()),
        ),
        GoRoute(
          path: '/${AppRoutes.communities}',
          builder: (context, state) =>
              const ApplyForEachPage(child: CommunitiesPage()),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return ApplyForEachPage(child: CommunityDetailPage(communityId: id));
              },
            ),
          ],
        ),
        GoRoute(
          path: '/${AppRoutes.superAdmin}',
          builder: (context, state) =>
              const ApplyForEachPage(child: SuperAdminPanelPage()),
        ),
      ],
    );

    return _cachedRouter!;
  }

  //static go to the home page
  static void goToHome(BuildContext context) {
    // Use go() to replace the entire navigation stack, preventing back navigation
    GoRouter.of(context).go('/${AppRoutes.home}');
  }

  //static go to the login page
  static void goToLogin(BuildContext context) {
    // Use go() to replace the entire navigation stack, preventing back navigation
    GoRouter.of(context).go(AppRoutes.login);
  }

  //static go to the register page
  static void goToRegister(BuildContext context) {
    // Use go() to replace the entire navigation stack, preventing back navigation
    GoRouter.of(context).go('/${AppRoutes.register}');
  }

  static void goToCommunities(BuildContext context) {
    GoRouter.of(context).go('/${AppRoutes.communities}');
  }

  //static go back
  static void goBack(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      final currentLocation = router.routerDelegate.currentConfiguration.uri.path;
      
      // Prevent going back to login/register if authenticated
      // This is a safety check in addition to the redirect logic
      if (router.canPop()) {
        router.pop();
        return;
      }

      // If we can't pop and we're at a root route, do nothing
      // This prevents navigation back to login/register
      if (currentLocation == '/${AppRoutes.home}' || 
          currentLocation == AppRoutes.login || 
          currentLocation == '/${AppRoutes.register}') {
        // At root route, don't navigate anywhere
        return;
      }

      // Fallback: try to navigate to parent route
      if (currentLocation.isNotEmpty && currentLocation != '/') {
        final lastSlashIndex = currentLocation.lastIndexOf('/');
        if (lastSlashIndex > 0) {
          final parentLocation = currentLocation.substring(0, lastSlashIndex);
          router.go(parentLocation);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in AppRoutes.goBack: $e');
      }
      // If everything else fails, try standard navigator pop only if we can
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }
}
