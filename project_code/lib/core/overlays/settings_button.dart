import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import 'settings_bottom_sheet.dart';

/// Reusable settings button that opens the settings bottom sheet.
/// 
/// This widget can be placed in any app bar or toolbar to provide
/// access to app settings (theme color, language, logout).
/// 
/// Example usage:
/// ```dart
/// AppBar(
///   title: Text('My Page'),
///   actions: [
///     SettingsButton(),
///   ],
/// )
/// ```
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocalizationController>().getLanguage();

    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: lang.settings ?? 'Settings',
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const SettingsBottomSheet(),
        );
      },
    );
  }
}
