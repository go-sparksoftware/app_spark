import 'package:flutter/material.dart';

import '../material_symbols.dart';
import 'theme_mode_controller.dart';

class ThemeModeToggleButton extends StatelessWidget {
  const ThemeModeToggleButton(
      {super.key, this.onToggle, this.popOnToggle = false});

  final Function()? onToggle;
  final bool popOnToggle;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: ThemeModeController.instance,
        builder: (context, child) => IconButton(
          icon: Icon(toggleIcon),
          onPressed: () {
            ThemeModeController.instance.toggleThemeMode2();
            onToggle?.call();
            final navigator = Navigator.of(context);

            if (popOnToggle && navigator.canPop()) {
              navigator.pop();
            }
          },
        ),
      );

  IconData get toggleIcon => switch (ThemeModeController.instance.themeMode) {
        ThemeMode.light => MaterialSymbols.darkMode,
        ThemeMode.dark => MaterialSymbols.lightMode,
        ThemeMode.system => MaterialSymbols.lightMode
      };
}
