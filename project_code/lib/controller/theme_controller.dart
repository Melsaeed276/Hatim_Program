import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends ChangeNotifier {
  final _themeBox = Hive.box('theme');

  static const String _seedColorKey = 'seedColor';
  static const int _defaultSeedColorValue = 0xFF4CAF50; // Colors.green

  /// Palette presented in the Settings sheet.
  static const List<Color> seedColorOptions = <Color>[
    Color(0xFF4CAF50), // green
    Color(0xFF2196F3), // blue
    Color(0xFFF44336), // red
    Color(0xFFFFC107), // amber
    Color(0xFF9C27B0), // purple
    Color(0xFF009688), // teal
    Color(0xFF795548), // brown
    Color(0xFF607D8B), // blueGrey
  ];

  /// Returns the Material 3 seed color used for theming.
  /// Persisted in Hive so the user can change it from Settings.
  Color getSeedColor() {
    final int value =
        _themeBox.get(_seedColorKey, defaultValue: _defaultSeedColorValue)
            as int;
    return Color(value);
  }

  /// Sets the seed color and persists it to Hive.
  /// Notifies listeners to rebuild the app with the new theme.
  void setSeedColor(Color color) {
    _themeBox.put(_seedColorKey, color.value);
    notifyListeners();
  }

  /// Returns the app color (alias for getSeedColor for backward compatibility).
  Color getAppColor() {
    return getSeedColor();
  }
}
