import 'res_kit_breakpoints.dart';

/// Immutable Figma canvas dimensions.
class ResKitDesignSize {
  final double width;
  final double height;

  const ResKitDesignSize({required this.width, required this.height})
      : assert(width > 0), assert(height > 0);

  // ── Named presets ──────────────────────────────────────────────────────
  static const iphoneSE        = ResKitDesignSize(width: 375,  height: 667);
  static const iphone14        = ResKitDesignSize(width: 390,  height: 844);
  static const iphone14ProMax  = ResKitDesignSize(width: 430,  height: 932);
  static const iphone15ProMax  = ResKitDesignSize(width: 430,  height: 932);
  static const androidCommon   = ResKitDesignSize(width: 360,  height: 800);
  static const androidLarge    = ResKitDesignSize(width: 412,  height: 915);
  static const ipadMini        = ResKitDesignSize(width: 768,  height: 1024);
  static const ipadPro11       = ResKitDesignSize(width: 834,  height: 1194);
  static const ipadPro12       = ResKitDesignSize(width: 1024, height: 1366);
  static const macbookAir      = ResKitDesignSize(width: 1440, height: 900);
  static const webBrowser      = ResKitDesignSize(width: 1280, height: 800);
  static const fullHD          = ResKitDesignSize(width: 1920, height: 1080);
  static const qhd             = ResKitDesignSize(width: 2560, height: 1440);

  @override String toString() => 'ResKitDesignSize(${width.toStringAsFixed(0)}×${height.toStringAsFixed(0)})';
  @override bool operator ==(Object o) => o is ResKitDesignSize && o.width == width && o.height == height;
  @override int get hashCode => Object.hash(width, height);
}

/// Holds separate Figma canvases for every breakpoint.
///
/// ```dart
/// ResKitDesignConfig(
///   mobile:  ResKitDesignSize.iphone14,
///   tablet:  ResKitDesignSize.ipadMini,
///   desktop: ResKitDesignSize.macbookAir,
///   web:     ResKitDesignSize.webBrowser,
/// )
/// ```
class ResKitDesignConfig {
  final ResKitDesignSize? mobile;
  final ResKitDesignSize? mobileLarge;
  final ResKitDesignSize? tabletSmall;
  final ResKitDesignSize? tablet;
  final ResKitDesignSize? tabletLarge;
  final ResKitDesignSize? desktop;
  final ResKitDesignSize? desktopLarge;
  final ResKitDesignSize? web;

  const ResKitDesignConfig({
    this.mobile, this.mobileLarge, this.tabletSmall,
    this.tablet, this.tabletLarge, this.desktop,
    this.desktopLarge, this.web,
  }) : assert(mobile != null || tablet != null || desktop != null || web != null,
            'At least one design size must be provided.');

  static const ResKitDesignSize _fallback = ResKitDesignSize(width: 390, height: 844);

  ResKitDesignSize resolve({
    required double screenWidth,
    required bool isWebPlatform,
    required ResKitBreakpoints bp,
  }) {
    if (isWebPlatform && web != null) return web!;
    if (screenWidth >= bp.desktopLarge && desktopLarge != null) return desktopLarge!;
    if (screenWidth > bp.tabletLarge)
      return desktop ?? desktopLarge ?? tabletLarge ?? tablet ?? tabletSmall ?? mobileLarge ?? mobile ?? _fallback;
    if (screenWidth > bp.tablet && tabletLarge != null) return tabletLarge!;
    if (screenWidth > bp.tabletSmall)
      return tablet ?? tabletSmall ?? tabletLarge ?? mobileLarge ?? mobile ?? _fallback;
    if (screenWidth > bp.mobileLarge && tabletSmall != null) return tabletSmall!;
    if (screenWidth > bp.mobile && mobileLarge != null) return mobileLarge!;
    return mobile ?? tabletSmall ?? tablet ?? desktop ?? _fallback;
  }

  List<String> get configuredSlots {
    final list = <String>[];
    if (mobile       != null) list.add('mobile: $mobile');
    if (mobileLarge  != null) list.add('mobileLarge: $mobileLarge');
    if (tabletSmall  != null) list.add('tabletSmall: $tabletSmall');
    if (tablet       != null) list.add('tablet: $tablet');
    if (tabletLarge  != null) list.add('tabletLarge: $tabletLarge');
    if (desktop      != null) list.add('desktop: $desktop');
    if (desktopLarge != null) list.add('desktopLarge: $desktopLarge');
    if (web          != null) list.add('web: $web');
    return list;
  }
}
