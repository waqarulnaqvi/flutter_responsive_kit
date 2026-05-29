/// Breakpoint thresholds used throughout the package.
/// All values are logical pixel **widths**.
class ResKitBreakpoints {
  final double mobileSmall;   // ≤ 360
  final double mobile;        // ≤ 480
  final double mobileLarge;   // ≤ 600
  final double tabletSmall;   // 601
  final double tablet;        // ≤ 900
  final double tabletLarge;   // ≤ 1024
  final double desktop;       // > 1024
  final double desktopLarge;  // ≥ 1440
  final double desktopXL;     // ≥ 1920
  final double webMaxContent; // 1280

  const ResKitBreakpoints({
    this.mobileSmall   = 360,
    this.mobile        = 480,
    this.mobileLarge   = 600,
    this.tabletSmall   = 601,
    this.tablet        = 900,
    this.tabletLarge   = 1024,
    this.desktop       = 1025,
    this.desktopLarge  = 1440,
    this.desktopXL     = 1920,
    this.webMaxContent = 1280,
  });

  factory ResKitBreakpoints.bootstrap() => const ResKitBreakpoints(
        mobile: 576, mobileLarge: 576, tabletSmall: 577,
        tablet: 768, tabletLarge: 992, desktop: 993,
        desktopLarge: 1200, desktopXL: 1400, webMaxContent: 1200,
      );

  factory ResKitBreakpoints.material3() => const ResKitBreakpoints(
        mobile: 480, mobileLarge: 600, tabletSmall: 601,
        tablet: 840, tabletLarge: 1024, desktop: 1025,
        desktopLarge: 1440, desktopXL: 1920, webMaxContent: 1240,
      );

  factory ResKitBreakpoints.tailwind() => const ResKitBreakpoints(
        mobile: 480, mobileLarge: 640, tabletSmall: 641,
        tablet: 768, tabletLarge: 1024, desktop: 1025,
        desktopLarge: 1280, desktopXL: 1536, webMaxContent: 1280,
      );
}
