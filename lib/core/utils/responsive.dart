import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
}

/// Responsive utility class
class Responsive {
  final BuildContext context;
  final MediaQueryData mediaQuery;

  Responsive(this.context) : mediaQuery = MediaQuery.of(context);

  /// Screen width
  double get width => mediaQuery.size.width;

  /// Screen height
  double get height => mediaQuery.size.height;

  /// Screen orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Is mobile device
  bool get isMobile => width < Breakpoints.mobile;

  /// Is tablet device
  bool get isTablet => width >= Breakpoints.mobile && width < Breakpoints.desktop;

  /// Is desktop device
  bool get isDesktop => width >= Breakpoints.desktop;

  /// Is large desktop device
  bool get isLargeDesktop => width >= Breakpoints.largeDesktop;

  /// Get responsive padding
  EdgeInsets get padding {
    if (isMobile) {
      return const EdgeInsets.all(16);
    } else if (isTablet) {
      return const EdgeInsets.all(24);
    } else {
      return EdgeInsets.symmetric(
        horizontal: width * 0.1,
        vertical: 32,
      );
    }
  }

  /// Get responsive horizontal padding
  double get horizontalPadding {
    if (isMobile) {
      return 16;
    } else if (isTablet) {
      return 24;
    } else {
      return width * 0.1;
    }
  }

  /// Get responsive vertical padding
  double get verticalPadding {
    if (isMobile) {
      return 16;
    } else if (isTablet) {
      return 24;
    } else {
      return 32;
    }
  }

  /// Get responsive font size multiplier
  double get fontSizeMultiplier {
    if (isMobile) {
      return 1.0;
    } else if (isTablet) {
      return 1.1;
    } else {
      return 1.2;
    }
  }

  /// Get number of columns for grid
  int getGridColumns({int? mobile, int? tablet, int? desktop}) {
    if (isMobile) {
      return mobile ?? 1;
    } else if (isTablet) {
      return tablet ?? 2;
    } else {
      return desktop ?? 3;
    }
  }

  /// Get responsive card width
  double getCardWidth({double? mobile, double? tablet, double? desktop}) {
    if (isMobile) {
      return mobile ?? width * 0.85;
    } else if (isTablet) {
      return tablet ?? width * 0.45;
    } else {
      return desktop ?? width * 0.3;
    }
  }

  /// Get responsive item width for horizontal lists
  double getHorizontalItemWidth({double? mobile, double? tablet, double? desktop}) {
    if (isMobile) {
      return mobile ?? width * 0.7;
    } else if (isTablet) {
      return tablet ?? width * 0.4;
    } else {
      return desktop ?? width * 0.25;
    }
  }

  /// Get responsive spacing
  double getSpacing({double? mobile, double? tablet, double? desktop}) {
    if (isMobile) {
      return mobile ?? 16;
    } else if (isTablet) {
      return tablet ?? 24;
    } else {
      return desktop ?? 32;
    }
  }

  /// Get responsive icon size
  double getIconSize({double? mobile, double? tablet, double? desktop}) {
    if (isMobile) {
      return mobile ?? 24;
    } else if (isTablet) {
      return tablet ?? 28;
    } else {
      return desktop ?? 32;
    }
  }

  /// Get max content width (for centering content on large screens)
  double get maxContentWidth {
    if (isDesktop) {
      return Breakpoints.desktop;
    } else {
      return width;
    }
  }

  /// Check if should show side navigation
  bool get shouldShowSideNav => isDesktop;

  /// Check if should show bottom navigation
  bool get shouldShowBottomNav => !isDesktop;
}

/// Extension on BuildContext for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}


