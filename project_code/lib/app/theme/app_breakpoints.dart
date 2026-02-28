class AppBreakpoints {
  AppBreakpoints._();

  static const double compactMax = 599;
  static const double mediumMin = 600;
  static const double mediumMax = 839;
  static const double expandedMin = 840;

  static bool isCompact(double width) => width <= compactMax;

  static bool isMedium(double width) =>
      width >= mediumMin && width <= mediumMax;

  static bool isExpanded(double width) => width >= expandedMin;
}
