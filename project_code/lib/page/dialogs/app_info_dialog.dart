import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/contollers.dart';

class AppInfoDialog extends StatelessWidget {
  const AppInfoDialog({super.key});

  Future<void> _launchPhone(String phoneNumber) async {
    // Remove spaces and special characters for the scheme
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
    if (!await launchUrl(launchUri)) {
      debugPrint('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(
      context,
      listen: true,
    ).getLanguage();
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                lang.appInfoTitle ?? 'App Information',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              _buildSection(
                context,
                title: lang.aboutAppTitle ?? 'About App',
                content: lang.aboutAppDescription ?? '',
              ),

              _buildSection(
                context,
                title: lang.whyWeMadeAppTitle ?? 'Why we made this app',
                content: lang.whyWeMadeAppDescription ?? '',
              ),

              _buildSection(
                context,
                title:
                    lang.supporterCommunitiesTitle ?? 'Supporter Communities',
                content: lang.supporterCommunitiesList ?? '',
              ),
_buildSection(
                context,
                title:
                    lang.whoMadeThisAppTitle,
                content: lang.whoMadeThisAppDescription,
              ),
              Text(
                lang.contactSupportTitle ?? 'Contact Support',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.contactSupportDescription ?? '',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchPhone(lang.supportPhoneNumber ?? ''),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        lang.supportPhoneNumber ?? '',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(lang.close ?? 'Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
