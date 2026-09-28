import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class Responsive {
  static ScreenType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return ScreenType.desktop;
    if (width >= 650) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(BuildContext context) => of(context) == ScreenType.mobile;
  static bool isTablet(BuildContext context) => of(context) == ScreenType.tablet;
  static bool isDesktop(BuildContext context) => of(context) == ScreenType.desktop;

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return 1000;
    if (width >= 650) return width * 0.88;
    return width;
  }

  static double contentMaxWidth(BuildContext context) => contentWidth(context);

  static double contentPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return 32.0;
    if (width >= 650) return 24.0;
    return 16.0;
  }

  static double pagePadding(BuildContext context) => contentPadding(context);
  static double horizontalPadding(BuildContext context) => contentPadding(context);
  static int gridCrossAxisCount(BuildContext context) => gridColumns(context);

  static EdgeInsets contentInsets(BuildContext context) {
    final p = contentPadding(context);
    return EdgeInsets.symmetric(horizontal: p, vertical: p);
  }

  static int gridColumns(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
    return switch (of(context)) {
      ScreenType.desktop => desktop,
      ScreenType.tablet => tablet,
      ScreenType.mobile => mobile,
    };
  }

  static int gridCount(BuildContext context, {int mobile = 2, int tablet = 3, int desktop = 4}) {
    return gridColumns(context, mobile: mobile, tablet: tablet, desktop: desktop);
  }
}
