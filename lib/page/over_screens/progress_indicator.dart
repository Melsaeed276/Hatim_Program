import 'package:flutter/material.dart';

class ProgressIndicatorWithNumber extends StatelessWidget {
  final int currentValue;
  final int totalValue = 30;

  late final IconData? icon;
  late final String? textData;

  ProgressIndicatorWithNumber(
      {super.key,
      required this.currentValue,
      IconData? icon,
      String? textData}) {
    if (icon != null) {
      this.icon = icon;
    } else {
      this.icon =
          currentValue == 0 ? Icons.access_time_rounded : Icons.book_outlined;
    }

    if (textData != null) {
      this.textData = textData;
    } else {
      this.textData = '$currentValue / $totalValue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 5,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onTertiaryContainer.withOpacity(0.6),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              value: currentValue / totalValue, // This determines the progress
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1.0),
              child: Icon(icon, size: 20.0),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          textData!,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
