import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';
import '../../features/auth/controllers/controllers.dart';
import '../routing/page_route.dart';

/// Settings bottom sheet that allows users to:
/// - Change app theme color
/// - Change language
/// - Logout
class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationController = context.watch<LocalizationController>();
    final lang = localizationController.getLanguage();
    final themeController = context.watch<ThemeController>();
    final userController = context.read<UserController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lang.settings ?? 'Settings',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Theme Color Section
              Text(
                lang.applicationColor ?? 'App Color',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _ColorPicker(
                currentColor: themeController.getSeedColor(),
                onColorSelected: (color) {
                  HapticFeedback.lightImpact();
                  themeController.setSeedColor(color);
                },
              ),
              const SizedBox(height: 32),

              // Language Section
              Text(
                lang.language ?? 'Language',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _LanguageSelector(),
              const SizedBox(height: 32),

              // Theme Mode Section
              Text(
                lang.themeMode ?? 'Theme Mode',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              _ThemeModeSelector(),
              const SizedBox(height: 32),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    Navigator.pop(context);
                    _showLogoutDialog(context, userController, lang);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: theme.colorScheme.error,
                  ),
                  label: Text(
                    lang.logOut ?? 'Sign Out',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    minimumSize: const Size(0, 48),
                    side: BorderSide(
                      color: theme.colorScheme.error,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    UserController userController,
    dynamic lang,
  ) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.logout,
          color: theme.colorScheme.error,
          size: 48,
        ),
        title: Text(
          lang.logOut ?? 'Sign Out',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          lang.logoutDialogDescriptionText ?? 'Are you sure you want to log out?',
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Text(lang.logoutDialogCancelButtonText ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              userController.resetUser();
              Navigator.pop(dialogContext);
              // Use go() to replace navigation stack and prevent back navigation
              AppRoutes.goToLogin(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: Text(lang.logoutDialogLogoutButtonText ?? 'Logout'),
          ),
        ],
      ),
    );
  }
}

/// Color picker widget for selecting theme colors
class _ColorPicker extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorPicker({
    required this.currentColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ThemeController.seedColorOptions.map((color) {
        final isSelected = color == currentColor;
        return _ColorOption(
          color: color,
          isSelected: isSelected,
          onTap: () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}

/// Individual color option widget
class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorName = _getColorName(color);
    
    return Semantics(
      label: colorName,
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(
                    color: theme.colorScheme.onSurface,
                    width: 3,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: _getContrastColor(color),
                  size: 24,
                  semanticLabel: 'Selected $colorName',
                )
              : null,
        ),
      ),
    );
  }

  /// Returns a human-readable color name for accessibility
  String _getColorName(Color color) {
    // Map common Material colors to names
    if (color.value == 0xFF6750A4) return 'Purple';
    if (color.value == 0xFF1976D2) return 'Blue';
    if (color.value == 0xFF388E3C) return 'Green';
    if (color.value == 0xFFF57C00) return 'Orange';
    if (color.value == 0xFFD32F2F) return 'Red';
    if (color.value == 0xFF7B1FA2) return 'Deep Purple';
    if (color.value == 0xFF0288D1) return 'Light Blue';
    if (color.value == 0xFF00796B) return 'Teal';
    if (color.value == 0xFFE64A19) return 'Deep Orange';
    if (color.value == 0xFFC2185B) return 'Pink';
    return 'Color';
  }

  /// Returns a contrasting color (white or black) based on the background color
  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Language selector widget
class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langController = context.watch<LocalizationController>();
    final currentLang = langController.getAppLang;
    final languageTitles = langController.getLanguageTitles();

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: languageTitles.entries.map((entry) {
            final isSelected = currentLang == entry.key;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _LanguageOption(
                  languageCode: entry.key,
                  languageTitle: entry.value,
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      HapticFeedback.lightImpact();
                      langController.setAppLang = entry.key;
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Individual language option widget
class _LanguageOption extends StatelessWidget {
  final String languageCode;
  final String languageTitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.languageCode,
    required this.languageTitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$languageTitle language${isSelected ? ', selected' : ''}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(
            minHeight: 48, // Minimum touch target size
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            languageTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Theme mode selector widget
class _ThemeModeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = context.watch<ThemeController>();
    final currentThemeMode = themeController.getThemeMode();
    final localizationController = context.watch<LocalizationController>();
    final lang = localizationController.getLanguage();

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            _ThemeModeOption(
              themeMode: ThemeMode.system,
              themeTitle: lang.themeModeSystem ?? 'System',
              isSelected: currentThemeMode == ThemeMode.system,
              onTap: () {
                if (currentThemeMode != ThemeMode.system) {
                  HapticFeedback.lightImpact();
                  themeController.setThemeMode(ThemeMode.system);
                }
              },
            ),
            Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
            _ThemeModeOption(
              themeMode: ThemeMode.light,
              themeTitle: lang.themeModeLightMode ?? 'Light Mode',
              isSelected: currentThemeMode == ThemeMode.light,
              onTap: () {
                if (currentThemeMode != ThemeMode.light) {
                  HapticFeedback.lightImpact();
                  themeController.setThemeMode(ThemeMode.light);
                }
              },
            ),
            Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
            _ThemeModeOption(
              themeMode: ThemeMode.dark,
              themeTitle: lang.themelModeDarkMode ?? 'Dark Mode',
              isSelected: currentThemeMode == ThemeMode.dark,
              onTap: () {
                if (currentThemeMode != ThemeMode.dark) {
                  HapticFeedback.lightImpact();
                  themeController.setThemeMode(ThemeMode.dark);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual theme mode option widget
class _ThemeModeOption extends StatelessWidget {
  final ThemeMode themeMode;
  final String themeTitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeOption({
    required this.themeMode,
    required this.themeTitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: '$themeTitle${isSelected ? ', selected' : ''}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          constraints: const BoxConstraints(
            minHeight: 48, // Minimum touch target size
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(
                _getThemeModeIcon(themeMode),
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  themeTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate icon for the theme mode
  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.settings;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

