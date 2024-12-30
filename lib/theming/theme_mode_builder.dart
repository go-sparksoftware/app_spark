import 'package:flutter/material.dart';

import 'theme_mode_controller.dart';

class ThemeModeBuilder extends StatelessWidget {
  const ThemeModeBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, ThemeMode themeMode) builder;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: ThemeModeController.instance,
        builder: (context, child) =>
            builder(context, ThemeModeController.instance.themeMode),
      );
}
