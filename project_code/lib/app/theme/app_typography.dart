import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static TextTheme resolve(Locale locale) {
    final bool isArabic = locale.languageCode == 'ar';
    final String family = isArabic ? 'Noto Naskh Arabic' : 'Noto Sans';

    final TextTheme base = Typography.material2021().black;
    return base.apply(
      fontFamily: family,
      fontFamilyFallback: const [
        'Noto Sans',
        'Noto Naskh Arabic',
        'sans-serif',
      ],
    );
  }
}
