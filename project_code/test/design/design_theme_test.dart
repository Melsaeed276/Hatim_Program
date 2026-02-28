@Tags(['design'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatim_program/app/theme/app_theme.dart';
import 'package:hatim_program/app/theme/app_typography.dart';

void main() {
  test('light theme uses Material 3', () {
    final ThemeData theme = AppTheme.buildLightTheme(const Locale('en'));
    expect(theme.useMaterial3, isTrue);
  });

  test('Arabic locale resolves Arabic-first typography family', () {
    final textTheme = AppTypography.resolve(const Locale('ar'));
    expect(textTheme.bodyMedium?.fontFamily, 'Noto Naskh Arabic');
  });

  test('English locale resolves Latin typography family', () {
    final textTheme = AppTypography.resolve(const Locale('en'));
    expect(textTheme.bodyMedium?.fontFamily, 'Noto Sans');
  });
}
