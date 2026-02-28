import 'package:flutter/material.dart';

import '../../features/design_preview/presentation/design_preview_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String designPreview = '/';

  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required Locale locale,
    required ValueChanged<Locale> onLocaleChanged,
  }) {
    switch (settings.name) {
      case designPreview:
        return MaterialPageRoute<void>(
          builder: (_) => DesignPreviewPage(
            locale: locale,
            onLocaleChanged: onLocaleChanged,
          ),
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
