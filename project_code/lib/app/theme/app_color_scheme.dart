import 'package:flutter/material.dart';

class AppColorRoles {
  AppColorRoles._();

  static const Color seedEmerald = Color(0xFF0B7A65);

  static ColorScheme light() {
    return ColorScheme.fromSeed(
      seedColor: seedEmerald,
      brightness: Brightness.light,
    );
  }

  // Dark mode is specified for later implementation and design contract checks.
  static ColorScheme darkSpec() {
    return ColorScheme.fromSeed(
      seedColor: seedEmerald,
      brightness: Brightness.dark,
    );
  }
}
