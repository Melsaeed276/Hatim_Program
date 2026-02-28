import 'package:flutter/material.dart';

import '../../../app/theme/app_breakpoints.dart';
import '../../../app/theme/app_tokens.dart';
import 'widgets/design_components.dart';

class DesignPreviewPage extends StatelessWidget {
  const DesignPreviewPage({
    required this.locale,
    required this.onLocaleChanged,
    super.key,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Design System Preview')),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final String widthClass = _widthClass(constraints.maxWidth);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTokens.spaceLg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Issue #8 UI Foundation',
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppTokens.spaceSm),
                  Text(
                    'Current layout class: $widthClass',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTokens.spaceLg),
                  _LocaleSelector(
                    locale: locale,
                    onLocaleChanged: onLocaleChanged,
                  ),
                  const SizedBox(height: AppTokens.spaceLg),
                  const _MvpScreenSpecsSection(),
                  const SizedBox(height: AppTokens.spaceLg),
                  const _ComponentShowcaseSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _widthClass(double width) {
    if (AppBreakpoints.isCompact(width)) {
      return 'Compact';
    }
    if (AppBreakpoints.isMedium(width)) {
      return 'Medium';
    }
    return 'Expanded';
  }
}

class _LocaleSelector extends StatelessWidget {
  const _LocaleSelector({required this.locale, required this.onLocaleChanged});

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Locale Preview',
      subtitle: 'Switch language direction and script behavior (EN/AR/TR).',
      child: Semantics(
        label: 'Locale selector',
        child: DropdownButtonFormField<Locale>(
          initialValue: locale,
          items: const <DropdownMenuItem<Locale>>[
            DropdownMenuItem(value: Locale('en'), child: Text('English')),
            DropdownMenuItem(value: Locale('ar'), child: Text('Arabic')),
            DropdownMenuItem(value: Locale('tr'), child: Text('Turkish')),
          ],
          onChanged: (Locale? selected) {
            if (selected != null) {
              onLocaleChanged(selected);
            }
          },
        ),
      ),
    );
  }
}

class _MvpScreenSpecsSection extends StatelessWidget {
  const _MvpScreenSpecsSection();

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'MVP Screen Preview Blocks',
      subtitle: 'Onboarding, signup, login, and prayer dashboard structures.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          _SpecListTile(
            title: 'Onboarding / Entry',
            subtitle: 'Purpose, quick intro, language switch, continue action.',
          ),
          _SpecListTile(
            title: 'Sign Up',
            subtitle: 'Phone/Google, name, optional reference code/password.',
          ),
          _SpecListTile(
            title: 'Login',
            subtitle: 'Phone flow with conditional password + Google option.',
          ),
          _SpecListTile(
            title: 'Home Prayer Dashboard',
            subtitle: 'Current prayer, next prayer, and countdown hierarchy.',
          ),
        ],
      ),
    );
  }
}

class _SpecListTile extends StatelessWidget {
  const _SpecListTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTokens.spaceMd),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceSm,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class _ComponentShowcaseSection extends StatelessWidget {
  const _ComponentShowcaseSection();

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Reusable Component Showcase',
      subtitle: 'Tokenized cards, status blocks, states, and actions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AppStatusBlock(
            title: 'Current Prayer',
            value: 'Asr - 16:26',
            caption: 'Next prayer Maghrib in 02:35:12',
          ),
          const SizedBox(height: AppTokens.spaceLg),
          Semantics(
            label: 'Primary action: Continue',
            button: true,
            child: FilledButton(
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: AppTokens.spaceMd),
          Semantics(
            label: 'Secondary action: Sign in with Google',
            button: true,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Sign in with Google'),
            ),
          ),
          const SizedBox(height: AppTokens.spaceMd),
          const AppLoadingState(label: 'Loading prayer timings...'),
          const SizedBox(height: AppTokens.spaceMd),
          const AppEmptyState(
            title: 'No prayer times yet',
            message: 'Set your location to load daily prayer schedule.',
          ),
          const SizedBox(height: AppTokens.spaceMd),
          const AppErrorState(
            message: 'Could not refresh prayer times. Please try again.',
          ),
        ],
      ),
    );
  }
}
