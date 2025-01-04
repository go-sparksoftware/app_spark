extension DoubleExtension on double {
  bool get isWhole => this == truncateToDouble();

  bool isWholeBy(int fractionDigits) {
    final whole = truncateToDouble();
    final fraction = double.parse(toStringAsFixed(fractionDigits));
    final isWhole = whole == fraction;
    return isWhole;
  }
}
