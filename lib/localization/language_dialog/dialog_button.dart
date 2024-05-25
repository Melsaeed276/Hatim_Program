import 'package:flutter/material.dart';


class DialogButton extends StatelessWidget {
  final String buttonText;
  final ThemeData theme;
  final MaterialStateProperty<Color?>? backgroundColor;
  final TextDirection langDirection;
  final Color? textColor;
  final VoidCallback? onPressed;
  final bool? isSelected;

  const DialogButton({
    super.key,
    required this.buttonText,
    required this.theme,
    this.backgroundColor,
    this.textColor,
    required this.langDirection,
    this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          alignment: langDirection == TextDirection.ltr
              ? Alignment.centerLeft
              : Alignment.centerRight,
          animationDuration: const Duration(seconds: 10),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: langDirection == TextDirection.ltr
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              isSelected == true && langDirection == TextDirection.ltr
                  ? Icon(
                      Icons.done,
                      color: textColor,
                    )
                  : const SizedBox(
                      width: 24,
                    ),
              if (langDirection == TextDirection.ltr) spacing(width: 8),
              Text(
                buttonText,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (langDirection == TextDirection.rtl) spacing(width: 8),
              isSelected == true && langDirection == TextDirection.rtl
                  ? Icon(
                      Icons.done,
                      color: textColor,
                    )
                  : const SizedBox(
                      width: 24,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox spacing({double? width}) => SizedBox(width: width);
}
