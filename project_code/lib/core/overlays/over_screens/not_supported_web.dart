import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/controllers/controllers.dart';
import '../../../features/auth/controllers/controllers.dart';
import 'bottom_sheet_lang_widget.dart';


class NotSupportedWebView extends StatelessWidget {
  final Widget child;

  const NotSupportedWebView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return child;
        } else {
          final lang = context.read<LocalizationController>().getLanguage();
          final user = context.watch<UserController>().userModel;
          final isSuperAdmin = user?.isSuperAdmin ?? false;

          // Allow large screens only for Super Admins (per spec/policy).
          if (isSuperAdmin) {
            return child;
          }
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.largeWebViewNotSupportedForAccount ??
                          'This screen is not supported for your account.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(lang.languageDialogDescription!),
                    const SizedBox(height: 20),
                    const BottomSheetLangWidget()
                  ],
                ),

              ),
            ),
          );
        }
      },
    );
  }
}
