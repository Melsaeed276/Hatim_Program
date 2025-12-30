import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/contollers.dart';

class SettingsDialog {
  /// Shows the settings bottom sheet dialog
  /// 
  /// [onLogout] is a callback function that will be called when the user taps the logout button
  /// [showLogoutButton] controls whether the logout button is displayed. Defaults to true.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onLogout,
    bool showLogoutButton = true,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);

        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
                bottom: 24 + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Consumer3<LocalizationController, UserController, ThemeController>(
                builder: (context, langController, userController, themeController, _) {
                  final lang = langController.getLanguage();
                  final currentSeed = themeController.getSeedColor().value;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          lang.settings ?? 'Settings',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Divider(height: 24),

                      // Preferences Section
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          lang.preferences ?? 'Preferences',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Language ListTile with Material 3 styling
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: ListTile(
                          leading: Icon(
                            Icons.language,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            lang.language ?? 'Language',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            langController.getLanguageTitle(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          onTap: () {
                            langController.getLanguageDialog(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Theme Section
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          lang.appearance ?? 'Appearance',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Theme Color Card
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.palette,
                                    color: theme.colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    lang.theme ?? 'Theme Color',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              StatefulBuilder(
                                builder:
                                    (
                                      BuildContext context,
                                      StateSetter setState,
                                    ) {
                                      return Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: ThemeController
                                            .seedColorOptions
                                            .map((c) {
                                              final isSelected =
                                                  c.value == currentSeed;
                                              return Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(28),
                                                  onTap: () {
                                                    themeController
                                                        .setSeedColor(c);
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    width: 48,
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: c,
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? theme
                                                                  .colorScheme
                                                                  .outline
                                                            : Colors
                                                                  .transparent,
                                                        width: 2,
                                                      ),
                                                      boxShadow: isSelected
                                                          ? [
                                                              BoxShadow(
                                                                color: c
                                                                    .withOpacity(
                                                                      0.4,
                                                                    ),
                                                                blurRadius: 8,
                                                                spreadRadius: 2,
                                                              ),
                                                            ]
                                                          : null,
                                                    ),
                                                    child: isSelected
                                                        ? Icon(
                                                            Icons.check_rounded,
                                                            color:
                                                                ThemeData.estimateBrightnessForColor(
                                                                      c,
                                                                    ) ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            size: 24,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            })
                                            .toList(),
                                      );
                                    },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Logout Button - Material 3 style (only shown if showLogoutButton is true)
                      if (showLogoutButton) ...[
                        const SizedBox(height: 24),
                        const Divider(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.tonal(
                            onPressed: () async {
                              Navigator.of(sheetContext).pop();
                              onLogout();
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.errorContainer,
                              foregroundColor: theme.colorScheme.onErrorContainer,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.logout_rounded),
                                const SizedBox(width: 8),
                                Text(
                                  lang.logOut ?? 'Logout',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
