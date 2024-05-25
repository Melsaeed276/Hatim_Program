import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../controller/contollers.dart';

class InternetCheckDialog extends StatelessWidget {
  const InternetCheckDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocalizationController>().getLanguage();
    return Consumer<ConnectionController>(
      builder: (context, value, child) {
        if (value.getIsConnected == false) {
          return Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: theme.shadowColor.withOpacity(0.9),
              ),
              Dialog(
                backgroundColor: theme.colorScheme.onSecondary,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            size: 45,
                            color: theme.colorScheme.surfaceTint,
                          ),
                          Icon(
                            Icons.signal_cellular_connected_no_internet_0_bar,
                            size: 45,
                            color: theme.colorScheme.surfaceTint,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        lang.noInternetWarningDialogText!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
