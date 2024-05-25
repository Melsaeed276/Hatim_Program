import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';

class UpdateHatimDialog extends StatelessWidget {

  final int chapter;
  const UpdateHatimDialog({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LocalizationController>(context, listen: true)
        .getLanguage();



    //Theme
    final theme = Theme.of(context);
     final themeColor = Theme.of(context).colorScheme;


      return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: themeColor.primary, size: 50),
          const SizedBox(width: 10),
          Expanded(child: Text(lang.areYouSureThatYouCompletedTheHatim!, textAlign: TextAlign.start,style: theme.textTheme.headlineSmall)),
        ],
      ),
      content:  Text(lang.didYouReadTheXChapterIfYesThenPressOnYesToUpdateYourHatimRound!(chapter:chapter), style: theme.textTheme.titleLarge),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor.primary,
                foregroundColor: themeColor.onPrimary,
              ),
              onPressed: () {

                // groupController.updateHatimStatus();
                Navigator.pop(context, true);
              },
              child: Text(lang.yes!, style: theme.textTheme.labelLarge!.copyWith(
                color: themeColor.onPrimary,
              )),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(lang.no!, style: theme.textTheme.labelLarge!.copyWith(
                color: themeColor.error,
              )),
            ),
          ),
        ],

    );
  }
}