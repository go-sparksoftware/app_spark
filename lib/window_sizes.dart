enum WindowClass {
  compact,
  medium,
  expanded,
  large,
  extraLarge;

  operator <(WindowClass other) => index < other.index;
  operator >(WindowClass other) => index > other.index;
  operator <=(WindowClass other) => index <= other.index;
  operator >=(WindowClass other) => index >= other.index;
}

class WindowSizes {
  static const materialCompactWidth = 600.0;
  static const materialMediumWidth = 840.0;
  static const materialExpandedWidth = 1200.0;
  static const materialLargeWidth = 1600.0;
  static const materialExtraLargeWidth = double.maxFinite;

  const WindowSizes(
      {required this.compactWidth,
      required this.mediumWidth,
      required this.expandedWidth,
      required this.largeWidth,
      required this.extraLargeWidth})
      : assert(extraLargeWidth > largeWidth),
        assert(largeWidth > expandedWidth),
        assert(expandedWidth > mediumWidth),
        assert(mediumWidth > compactWidth);

  const WindowSizes.material({
    double compactWidth = materialCompactWidth,
    double mediumWidth = materialMediumWidth,
    double expandedWidth = materialExpandedWidth,
    double largeWidth = materialLargeWidth,
    double extraLargeWidth = materialExtraLargeWidth,
  }) : this(
            compactWidth: compactWidth,
            mediumWidth: mediumWidth,
            expandedWidth: expandedWidth,
            largeWidth: largeWidth,
            extraLargeWidth: extraLargeWidth);

  final double compactWidth;
  final double mediumWidth;
  final double expandedWidth;
  final double largeWidth;
  final double extraLargeWidth;

  WindowClass classOf({required double width}) {
    if (width > largeWidth) return WindowClass.extraLarge;
    if (width > expandedWidth) return WindowClass.large;
    if (width > mediumWidth) return WindowClass.expanded;
    if (width > compactWidth) return WindowClass.medium;
    return WindowClass.compact;
  }
}
