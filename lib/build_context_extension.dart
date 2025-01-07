import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {
  void popOrHome() => canPop() ? pop() : go("/");
}
