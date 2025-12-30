import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hatim_program/page/admin_dashboard/admin_dashboard_page.dart';
import 'package:hatim_program/page/community/communities_page.dart';
import 'package:hatim_program/page/home_page.dart';
import 'package:hatim_program/page/profile_page.dart';
import 'package:hatim_program/service/community_services.dart';

class AppRouter {
  final CommunityServices _communityServices = CommunityServices();
  // TODO: Replace with actual user ID from auth service
  final String _currentUserId = 'user_placeholder';

  late final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/communities',
        builder: (context, state) => const CommunitiesPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: '/join/:communityId',
        builder: (context, state) {
          final communityId = state.pathParameters['communityId'];
          if (communityId != null) {
            _communityServices.joinCommunity(communityId, _currentUserId);
          }
          return const HomePage();
        },
      ),
    ],
  );
}
