import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user_profile.dart';

class AuthSessionPage extends StatelessWidget {
  const AuthSessionPage({
    required this.profile,
    required this.authRepository,
    required this.onOpenLocationSetup,
    super.key,
  });

  final AuthUserProfile profile;
  final AuthRepository authRepository;
  final VoidCallback onOpenLocationSetup;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Session')),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Welcome, ${profile.name}', style: textTheme.headlineSmall),
            const SizedBox(height: AppTokens.spaceLg),
            Text('UID: ${profile.uid}', style: textTheme.bodyMedium),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              'Phone: ${profile.phoneNumber ?? '-'}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              'Reference code: ${profile.referenceCode ?? '-'}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              'Providers: ${profile.authProviders.join(', ')}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              'Password enabled: ${profile.passwordEnabled ? 'Yes' : 'No'}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTokens.spaceLg),
            OutlinedButton(
              onPressed: onOpenLocationSetup,
              child: const Text('Location setup'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                await authRepository.signOut();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(
                  context,
                ).popUntil((Route<dynamic> route) => route.isFirst);
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
