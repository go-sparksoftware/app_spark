import 'package:app_spark/window_sizes.dart';

class BuildOptions {
  const BuildOptions(this.options, {required this.windowClass});
  const BuildOptions.empty({required this.windowClass}) : options = const {};

  final WindowClass windowClass;
  final Map<String, dynamic> options;

  dynamic operator [](String key) => options[key];
}
