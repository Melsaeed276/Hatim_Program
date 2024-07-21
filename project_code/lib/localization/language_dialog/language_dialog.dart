import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../controller/localization_controller.dart';
import 'dialog_button.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true);
    final theme = Theme.of(context);
    final scrollController = ScrollController();
    return Dialog(
      // insetAnimationDuration: const Duration(seconds: 2),

      backgroundColor: theme.colorScheme.surface,
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: lang.getLangDirection() == TextDirection.ltr
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                lang.getLanguage().language!,
                textAlign: lang.getLangDirection() == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              spacing(height: 5),
              Text(
                lang.getLanguage().languageDialogDescription!,
                textAlign: lang.getLangDirection() == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              spacing(height: 24),
              Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: lang.getLanguageTitles().length,
                  itemBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DialogButton(
                      langDirection: lang.getLangDirection(),
                      isSelected: lang.getLanguageTitle() ==
                          lang.getLanguageTitles().values.elementAt(index),
                      buttonText:
                          lang.getLanguageTitles().values.elementAt(index),
                      theme: theme,
                      backgroundColor: lang.getLanguageTitle() ==
                              lang.getLanguageTitles().values.elementAt(index)
                          ? WidgetStateProperty.all(
                              theme.colorScheme.secondaryContainer)
                          : WidgetStateProperty.all(Colors.transparent),
                      textColor: lang.getLanguageTitle() ==
                              lang.getLanguageTitles().values.elementAt(index)
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      onPressed: lang.getLanguageTitle() ==
                              lang.getLanguageTitles().values.elementAt(index)
                          ? () {
                              Navigator.pop(context);
                            }
                          : () {
                              lang.setAppLang =
                                  lang.languages.keys.elementAt(index);
                            //delay then pop
                            Future.delayed(const Duration(milliseconds: 250), () {
                              Navigator.pop(context);
                            });
                            },
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

  SizedBox spacing({double? width,double? height}) => SizedBox(width: width,height: height);
}
