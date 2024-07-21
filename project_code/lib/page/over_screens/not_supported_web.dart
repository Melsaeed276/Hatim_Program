import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
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
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context
                          .read<LocalizationController>()
                          .getLanguage()
                          .largeWebViewError!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text( context
                        .read<LocalizationController>()
                        .getLanguage()
                        .languageDialogDescription!,),
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
