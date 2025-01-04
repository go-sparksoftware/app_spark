extension IntExtension on int {
  String get padded => toString().padLeft(2, "0");
}
