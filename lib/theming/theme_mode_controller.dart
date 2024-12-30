import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeModeController._({ThemeMode? initialThemeMode})
      : _themeMode = initialThemeMode ?? ThemeMode.light;

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    if (value == _themeMode) return;
    _themeMode = value;
    notifyListeners();
  }

  void toggleThemeMode2() {
    themeMode = switch (themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light
    };
  }

  void toggleThemeMode3() {
    themeMode = switch (themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light
    };
  }

  static final instance = ThemeModeController._();
}
