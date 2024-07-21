import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';

class BottomSheetLangWidget extends StatelessWidget {
  const BottomSheetLangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langController =
        Provider.of<LocalizationController>(context, listen: true);
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        )),
        overlayColor: WidgetStateProperty.all(theme.colorScheme.secondary),
        side: WidgetStateProperty.all(
          BorderSide(
            color: theme.colorScheme.primary,
            width: 1.5,
          ),
        ),
        // backgroundColor: MaterialStateProperty.all(
        //     theme.colorScheme.primary),
      ),
      onPressed: () {
        langController.getLanguageDialog(context);
      },
      child: Text(
        langController.getLanguageTitle(),
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
