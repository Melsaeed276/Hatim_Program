import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/controllers.dart';

class ZikirComingSoon extends StatelessWidget {
  const ZikirComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            lang.zikirTab ?? 'Zikir',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lang.comingSoon ?? 'Coming Soon',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
