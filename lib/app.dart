import 'package:flutter/material.dart';

abstract class AppWidget<T extends AppOptions> extends StatelessWidget {
  const AppWidget({super.key});

  Color get primaryColor;

  T optionsOf(BuildContext context);
}

abstract class AppOptions {
  const AppOptions();
}

class StandardAppOptions extends AppOptions {
  const StandardAppOptions(
    this.context, {
    ShapeBorder? dialogShape,
    TextStyle? dialogTitleTextStyle,
  })  : _dialogTitleTextStyle = dialogTitleTextStyle,
        _dialogShape = dialogShape;
  final BuildContext context;

  TextStyle? get dialogTitleTextStyle =>
      _dialogTitleTextStyle ?? Theme.of(context).textTheme.headlineSmall;
  final TextStyle? _dialogTitleTextStyle;

  final ShapeBorder? _dialogShape;
  ShapeBorder get dialogShape => _dialogShape ?? defaultDialogShape;

  static final defaultDialogShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
}
