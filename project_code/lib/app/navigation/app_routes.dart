import 'package:flutter/material.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/auth_user_profile.dart';
import '../../features/auth/presentation/auth_session_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/design_preview/presentation/design_preview_page.dart';
import '../../features/prayer_times/location/presentation/location_setup_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String register = '/register';
  static const String session = '/session';
  static const String locationSetup = '/location-setup';
  static const String designPreview = '/design-preview';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required AuthRepository authRepository,
    required Locale locale,
    required ValueChanged<Locale> onLocaleChanged,
  }) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginPage(
            authRepository: authRepository,
            onRegisterPressed: () {
              Navigator.of(context).pushNamed(register);
            },
            onAuthSuccess: (AuthUserProfile profile) {
              Navigator.of(
                context,
              ).pushReplacementNamed(session, arguments: profile);
            },
          ),
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => RegisterPage(
            authRepository: authRepository,
            onLoginPressed: () {
              Navigator.of(context).pushReplacementNamed(login);
            },
            onAuthSuccess: (AuthUserProfile profile) {
              Navigator.of(
                context,
              ).pushReplacementNamed(session, arguments: profile);
            },
          ),
        );
      case session:
        final AuthUserProfile? profile = settings.arguments as AuthUserProfile?;
        if (profile == null) {
          return MaterialPageRoute<void>(
            builder: (BuildContext _) => const Scaffold(
              body: Center(child: Text('Missing session data')),
            ),
          );
        }
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => AuthSessionPage(
            profile: profile,
            authRepository: authRepository,
            onOpenLocationSetup: () {
              Navigator.of(context).pushNamed(locationSetup);
            },
          ),
        );
      case locationSetup:
        return MaterialPageRoute<void>(
          builder: (BuildContext _) => const LocationSetupPage(),
        );
      case designPreview:
        return MaterialPageRoute<void>(
          builder: (BuildContext _) => DesignPreviewPage(
            locale: locale,
            onLocaleChanged: onLocaleChanged,
          ),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (BuildContext _) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
