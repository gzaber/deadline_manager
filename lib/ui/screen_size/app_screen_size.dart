import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

class AppScreenSize {
  static const tabletBreakpoint = 600.0;
  static const desktopBreakpoint = 840.0;

  static ScreenSize getSize(BuildContext context) =>
      switch (MediaQuery.of(context).size.width) {
        > desktopBreakpoint => ScreenSize.desktop,
        > tabletBreakpoint => ScreenSize.tablet,
        _ => ScreenSize.mobile,
      };
}
