import 'package:flutter/material.dart';

extension ListExtension on List<Widget> {
  List<Widget> withSymmetricSpacing(
      {double vertical = 0, double horizontal = 0}) {
    return map((widget) => Padding(
        padding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: widget)).toList();
  }
}
