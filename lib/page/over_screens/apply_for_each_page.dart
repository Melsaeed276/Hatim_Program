import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/contollers.dart';
import 'over_screens.dart';

class ApplyForEachPage extends StatelessWidget {
  final Widget child;
  const ApplyForEachPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return NotSupportedWebView(
      child: Stack(
        children: [
          directionalityWidget(context, child),
          directionalityWidget(
            context,
            const InternetCheckDialog(),
          ),
        ],
      ),
    );
  }

  Widget directionalityWidget(BuildContext context, Widget child) {
    final lang = context.watch<LocalizationController>();
    return Directionality(
        textDirection: TextDirection.values
            .byName(lang.getAppLang == 'ar' ? 'rtl' : 'ltr'),
        child: child);
  }
}
