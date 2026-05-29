import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'res_kit_config.dart';
import 'res_kit_breakpoints.dart';
import 'res_kit_design_config.dart';
import '../platform/res_kit_platform.dart';
import '../platform/res_kit_os.dart';

/// Global responsive namespace. Call anywhere — no context needed.
///
/// Initialize once by wrapping your app with [ResponsiveKit].
class ResKit {
  ResKit._();

  static MediaQueryData? _mq;
  static ResKitConfig _config = const ResKitConfig();
  static bool _initialised = false;
  static ResKitDesignSize? _activeDesign;

  // ── Init ──────────────────────────────────────────────────────────────
  static void init({required MediaQueryData mediaQuery, required ResKitConfig config}) {
    _mq          = mediaQuery;
    _config      = config;
    _initialised = true;
    _activeDesign = config.resolveDesign(
      screenWidth: mediaQuery.size.width,
      isWeb: ResKitPlatform.isWeb,
    );
  }

  static void _assertInit() {
    assert(_initialised,
      '\n[flutter_responsive_plus] ResKit not initialised!\n'
      'Wrap your app root with ResponsiveKit(config: ResKitConfig(…), child: …)\n');
  }

  // ── Active Design Canvas ──────────────────────────────────────────────
  static ResKitDesignSize get activeDesign { _assertInit(); return _activeDesign!; }
  static double get figmaWidth  => activeDesign.width;
  static double get figmaHeight => activeDesign.height;

  // ── Config / MQ ───────────────────────────────────────────────────────
  static MediaQueryData    get mq         { _assertInit(); return _mq!; }
  static ResKitConfig      get config     { _assertInit(); return _config; }
  static ResKitBreakpoints get breakpoints => config.breakpoints;

  // ── Screen ────────────────────────────────────────────────────────────
  static Size   get size             => mq.size;
  static double get screenWidth      => mq.size.width;
  static double get screenHeight     => mq.size.height;
  static double get devicePixelRatio => mq.devicePixelRatio;
  static double get statusBarHeight  => mq.padding.top;
  static double get bottomBarHeight  => mq.viewInsets.bottom + mq.padding.bottom;
  static double get appBarHeight     => kToolbarHeight + statusBarHeight;
  static double get keyboardHeight   => mq.viewInsets.bottom;
  static bool   get isKeyboardOpen   => mq.viewInsets.bottom > 0;
  static EdgeInsets get safeAreaPadding => mq.padding;
  static double get diagonal =>
      math.sqrt(math.pow(screenWidth, 2) + math.pow(screenHeight, 2));

  // ── Scale Factors ─────────────────────────────────────────────────────
  static double get scaleW => screenWidth  / figmaWidth;
  static double get scaleH => screenHeight / figmaHeight;
  static double get scale  => math.min(scaleW, scaleH);
  static double get textScale {
    final s = scale;
    final max = config.maxFontScale;
    return max != null ? s.clamp(0.5, max) : s;
  }

  // ── Core Sizing API ───────────────────────────────────────────────────
  /// Scale a Figma width value to screen width.
  static double width(num v)  => v * scaleW;
  static double w(num v)      => width(v);

  /// Scale a Figma height value to screen height.
  static double height(num v) => v * scaleH;
  static double h(num v)      => height(v);

  /// Uniform scale — min(scaleW, scaleH). Use for radii and icons.
  static double radius(num v) => v * scale;
  static double r(num v)      => radius(v);

  /// Scale a Figma font size. Clamped by maxFontScale.
  static double sp(num v)     => v * textScale;

  /// Raw logical pixels — no scaling.
  static double dp(num v)     => v.toDouble();
  static double pt(num v)     => v.toDouble();

  /// Fraction of screen width. sw(0.5) = 50% of screen width.
  static double sw(double f)  => screenWidth  * f;

  /// Fraction of screen height. sh(0.1) = 10% of screen height.
  static double sh(double f)  => screenHeight * f;

  // ── Fluid Typography ──────────────────────────────────────────────────
  /// Fluid font size: linearly interpolates between [minSp] and [maxSp]
  /// as screen width moves from [minWidth] to [maxWidth].
  /// Like CSS clamp(minSp, vw, maxSp).
  static double fluidSp({
    required double minSp,
    required double maxSp,
    double? minWidth,
    double? maxWidth,
  }) {
    final bp     = breakpoints;
    final minW   = minWidth  ?? bp.mobile.toDouble();
    final maxW   = maxWidth  ?? bp.desktopLarge.toDouble();
    final factor = ((screenWidth - minW) / (maxW - minW)).clamp(0.0, 1.0);
    return sp(minSp + (maxSp - minSp) * factor);
  }

  // ── EdgeInsets / BorderRadius helpers ─────────────────────────────────
  static EdgeInsets symmetric({num vertical = 0, num horizontal = 0}) =>
      EdgeInsets.symmetric(vertical: height(vertical), horizontal: width(horizontal));
  static EdgeInsets only({num left=0, num top=0, num right=0, num bottom=0}) =>
      EdgeInsets.only(left: width(left), top: height(top), right: width(right), bottom: height(bottom));
  static EdgeInsets all(num v)       => EdgeInsets.all(radius(v));
  static BorderRadius circular(num v)=> BorderRadius.circular(radius(v));
  static Size squareSize(num v)      => Size(width(v), height(v));

  // ── RTL-aware helpers ─────────────────────────────────────────────────
  /// Returns left value in LTR, right value in RTL.
  static double start(num v, {required TextDirection direction}) =>
      direction == TextDirection.rtl ? width(v) : width(v);

  /// RTL-aware EdgeInsets: start = logical start (left in LTR, right in RTL).
  static EdgeInsetsDirectional directional({
    num start = 0, num top = 0, num end = 0, num bottom = 0,
  }) => EdgeInsetsDirectional.only(
    start:  width(start),
    top:    height(top),
    end:    width(end),
    bottom: height(bottom),
  );

  // ── ScreenUtil compat ─────────────────────────────────────────────────
  static double setWidth(num v)  => width(v);
  static double setHeight(num v) => height(v);
  static double setSp(num v)     => sp(v);

  // ── Orientation ───────────────────────────────────────────────────────
  static Orientation get orientation => mq.orientation;
  static bool get isPortrait  => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  // ── Breakpoints ───────────────────────────────────────────────────────
  static bool get isMobileSmall  => screenWidth <= breakpoints.mobileSmall;
  static bool get isMobile       => screenWidth <= breakpoints.mobile;
  static bool get isMobileLarge  => screenWidth <= breakpoints.mobileLarge;
  static bool get isTabletSmall  => screenWidth > breakpoints.mobileLarge && screenWidth <= breakpoints.tablet;
  static bool get isTablet       => screenWidth > breakpoints.mobileLarge && screenWidth <= breakpoints.tabletLarge;
  static bool get isTabletLarge  => screenWidth > breakpoints.tablet && screenWidth <= breakpoints.tabletLarge;
  static bool get isDesktop      => screenWidth > breakpoints.tabletLarge;
  static bool get isDesktopLarge => screenWidth >= breakpoints.desktopLarge;
  static bool get isDesktopXL    => screenWidth >= breakpoints.desktopXL;

  static ResKitDeviceType get deviceType {
    if (isMobile) return ResKitDeviceType.mobile;
    if (isTablet) return ResKitDeviceType.tablet;
    return ResKitDeviceType.desktop;
  }

  // ── Platform ──────────────────────────────────────────────────────────
  static ResKitOS get platform       => ResKitPlatform.current;
  static bool get isAndroid          => ResKitPlatform.isAndroid;
  static bool get isIOS              => ResKitPlatform.isIOS;
  static bool get isWeb              => ResKitPlatform.isWeb;
  static bool get isMacOS            => ResKitPlatform.isMacOS;
  static bool get isWindows          => ResKitPlatform.isWindows;
  static bool get isLinux            => ResKitPlatform.isLinux;
  static bool get isFuchsia          => ResKitPlatform.isFuchsia;
  static bool get isNativeDesktop    => ResKitPlatform.isNativeDesktop;
  static bool get isNativeMobile     => ResKitPlatform.isNativeMobile;

  // ── Accessibility ─────────────────────────────────────────────────────
  static bool get reducedMotion      => mq.disableAnimations;
  static bool get highContrast       => mq.highContrast;
  static bool get boldText           => mq.boldText;
  static bool get invertColors       => mq.invertColors;
  static bool get accessibleNavigation => mq.accessibleNavigation;
  static double get systemTextScaleFactor => mq.textScaler.scale(1.0);

  // ── RTL ───────────────────────────────────────────────────────────────
  static bool isRTL(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  // ── Adaptive helpers ──────────────────────────────────────────────────
  static T adaptive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet)  return tablet  ?? mobile;
    return mobile;
  }

  static T perPlatform<T>({
    T? android, T? ios, T? web, T? macOS, T? windows, T? linux, T? fuchsia,
    required T fallback,
  }) => ResKitPlatform.select(
    android: android, ios: ios, web: web,
    macOS: macOS, windows: windows, linux: linux, fuchsia: fuchsia,
    fallback: fallback,
  );

  // ── ResKit.builder ────────────────────────────────────────────────────
  /// The ultimate multi-layout builder. Supply widgets or builder callbacks
  /// for every screen size category. Only [mobile] is required.
  ///
  /// ```dart
  /// ResKit.builder(
  ///   mobile:  MobileScreen(),
  ///   tablet:  TabletScreen(),
  ///   desktop: DesktopScreen(),
  ///   web:     WebScreen(),     // platform override
  /// )
  /// ```
  // ── ResKit.builder ────────────────────────────────────────────────────
  /// The ultimate multi-layout builder. Supply widgets or builder callbacks
  /// for every screen size category. Only [mobile] is required.
  static Widget builder({
    // Static widgets
    Widget? mobile, Widget? mobileLarge, Widget? tabletSmall,
    Widget? tablet, Widget? tabletLarge, Widget? desktop,
    Widget? desktopLarge, Widget? desktopXL, Widget? web,
    // Builder callbacks
    Widget Function(BuildContext)? mobileBuilder,
    Widget Function(BuildContext)? mobileLargeBuilder,
    Widget Function(BuildContext)? tabletSmallBuilder,
    Widget Function(BuildContext)? tabletBuilder,
    Widget Function(BuildContext)? tabletLargeBuilder,
    Widget Function(BuildContext)? desktopBuilder,
    Widget Function(BuildContext)? desktopLargeBuilder,
    Widget Function(BuildContext)? desktopXLBuilder,
    Widget Function(BuildContext)? webBuilder,
    // Optional info callback
    void Function(ResKitLayoutInfo)? onLayout,
  }) {
    assert(mobile != null || mobileBuilder != null,
    '[ResKit.builder] mobile or mobileBuilder is required.');

    return _ResKitBuilderWidget(
      // FIX: Provide a guaranteed non-null closure. The assert above ensures
      // 'mobile' won't be null if 'mobileBuilder' is missing.
      mobileB:       mobileBuilder       ?? (_) => mobile!,
      mobileLargeB:  mobileLargeBuilder  ?? (mobileLarge  != null ? (_) => mobileLarge  : null),
      tabletSmallB:  tabletSmallBuilder  ?? (tabletSmall  != null ? (_) => tabletSmall  : null),
      tabletB:       tabletBuilder       ?? (tablet       != null ? (_) => tablet       : null),
      tabletLargeB:  tabletLargeBuilder  ?? (tabletLarge  != null ? (_) => tabletLarge  : null),
      desktopB:      desktopBuilder      ?? (desktop      != null ? (_) => desktop      : null),
      desktopLargeB: desktopLargeBuilder ?? (desktopLarge != null ? (_) => desktopLarge : null),
      desktopXLB:    desktopXLBuilder    ?? (desktopXL    != null ? (_) => desktopXL    : null),
      webB:          webBuilder          ?? (web          != null ? (_) => web          : null),
      onLayout: onLayout,
    );
  }

  // ── Debug ─────────────────────────────────────────────────────────────
  static void debugPrint() {
    if (!_initialised) {
      // ignore: avoid_print
      print('[ResKit] ❌ Not initialised. Wrap app with ResponsiveKit.');
      return;
    }
    final sep = '─' * 64;
    final d = config.designs;
    // ignore: avoid_print
    print('''
[ResKit] $sep
[ResKit] 📱  flutter_responsive_plus v2.0 — Diagnostic Dump
[ResKit] $sep
[ResKit] ── Design Config ───────────────────────────────────────────────
[ResKit]   Mode           : ${d != null ? 'Multi-canvas (per-breakpoint)' : 'Single-canvas'}
[ResKit]   Active canvas  : $activeDesign
${d != null ? d.configuredSlots.map((s) => '[ResKit]   $s').join('\n') : '[ResKit]   figma: ${figmaWidth}x$figmaHeight'}
[ResKit] ── Screen ──────────────────────────────────────────────────────
[ResKit]   Logical size   : ${screenWidth.toStringAsFixed(1)} × ${screenHeight.toStringAsFixed(1)} dp
[ResKit]   Physical size  : ${(screenWidth*devicePixelRatio).toStringAsFixed(0)} × ${(screenHeight*devicePixelRatio).toStringAsFixed(0)} px
[ResKit]   Pixel ratio    : ${devicePixelRatio.toStringAsFixed(2)}
[ResKit]   Orientation    : ${isPortrait ? 'Portrait ↕' : 'Landscape ↔'}
[ResKit]   Diagonal       : ${diagonal.toStringAsFixed(1)} dp
[ResKit] ── Scale Factors ───────────────────────────────────────────────
[ResKit]   scaleW         : ${scaleW.toStringAsFixed(5)}
[ResKit]   scaleH         : ${scaleH.toStringAsFixed(5)}
[ResKit]   scale          : ${scale.toStringAsFixed(5)}
[ResKit]   textScale      : ${textScale.toStringAsFixed(5)}
[ResKit] ── Breakpoints ─────────────────────────────────────────────────
[ResKit]   isMobileSmall  : $isMobileSmall  (≤${breakpoints.mobileSmall})
[ResKit]   isMobile       : $isMobile  (≤${breakpoints.mobile})
[ResKit]   isMobileLarge  : $isMobileLarge  (≤${breakpoints.mobileLarge})
[ResKit]   isTabletSmall  : $isTabletSmall
[ResKit]   isTablet       : $isTablet
[ResKit]   isTabletLarge  : $isTabletLarge
[ResKit]   isDesktop      : $isDesktop
[ResKit]   isDesktopLarge : $isDesktopLarge  (≥${breakpoints.desktopLarge})
[ResKit]   isDesktopXL    : $isDesktopXL  (≥${breakpoints.desktopXL})
[ResKit]   deviceType     : $deviceType
[ResKit] ── Safe Area ────────────────────────────────────────────────────
[ResKit]   statusBarHeight  : ${statusBarHeight.toStringAsFixed(1)} dp
[ResKit]   bottomBarHeight  : ${bottomBarHeight.toStringAsFixed(1)} dp
[ResKit]   keyboardHeight   : ${keyboardHeight.toStringAsFixed(1)} dp
[ResKit]   isKeyboardOpen   : $isKeyboardOpen
[ResKit] ── Accessibility ──────────────────────────────────────────────
[ResKit]   reducedMotion      : $reducedMotion
[ResKit]   highContrast       : $highContrast
[ResKit]   boldText           : $boldText
[ResKit]   invertColors       : $invertColors
[ResKit]   systemTextScale    : ${systemTextScaleFactor.toStringAsFixed(2)}
[ResKit] ── Platform ──────────────────────────────────────────────────
[ResKit]   OS             : $platform
[ResKit]   isAndroid      : $isAndroid
[ResKit]   isIOS          : $isIOS
[ResKit]   isWeb          : $isWeb
[ResKit]   isMacOS        : $isMacOS
[ResKit]   isWindows      : $isWindows
[ResKit]   isLinux        : $isLinux
[ResKit]   isFuchsia      : $isFuchsia
[ResKit] ── Sample Values ──────────────────────────────────────────────
[ResKit]   width(100)  → ${width(100).toStringAsFixed(2)}  height(100) → ${height(100).toStringAsFixed(2)}
[ResKit]   radius(12)  → ${radius(12).toStringAsFixed(2)}  sp(16)      → ${sp(16).toStringAsFixed(2)}
[ResKit]   sw(0.5)     → ${sw(0.5).toStringAsFixed(2)}  sh(0.1)     → ${sh(0.1).toStringAsFixed(2)}
[ResKit]   fluidSp(12,24) → ${fluidSp(minSp: 12, maxSp: 24).toStringAsFixed(2)}
[ResKit] $sep
''');
  }
}

// ── Internal builder widget ──────────────────────────────────────────────────
class _ResKitBuilderWidget extends StatelessWidget {
  const _ResKitBuilderWidget({
    required this.mobileB,
    this.mobileLargeB, this.tabletSmallB, this.tabletB,
    this.tabletLargeB, this.desktopB, this.desktopLargeB,
    this.desktopXLB, this.webB, this.onLayout,
  });

  final Widget Function(BuildContext) mobileB;
  final Widget Function(BuildContext)? mobileLargeB, tabletSmallB, tabletB,
      tabletLargeB, desktopB, desktopLargeB, desktopXLB, webB;
  final void Function(ResKitLayoutInfo)? onLayout;

  @override
  Widget build(BuildContext context) {
    final w   = MediaQuery.of(context).size.width;
    final bp  = ResKit.breakpoints;
    final web = ResKitPlatform.isWeb;

    late Widget Function(BuildContext) chosen;
    late ResKitLayoutType type;

    if (web && webB != null)                         { chosen = webB!;          type = ResKitLayoutType.web; }
    else if (w >= bp.desktopXL && desktopXLB != null){ chosen = desktopXLB!;    type = ResKitLayoutType.desktopXL; }
    else if (w >= bp.desktopLarge && desktopLargeB != null){ chosen = desktopLargeB!; type = ResKitLayoutType.desktopLarge; }
    else if (w > bp.tabletLarge)  { chosen = desktopB ?? tabletLargeB ?? tabletB ?? tabletSmallB ?? mobileLargeB ?? mobileB; type = ResKitLayoutType.desktop; }
    else if (w > bp.tablet && tabletLargeB != null)  { chosen = tabletLargeB!;  type = ResKitLayoutType.tabletLarge; }
    else if (w > bp.mobileLarge)  { chosen = tabletB ?? tabletSmallB ?? mobileLargeB ?? mobileB; type = ResKitLayoutType.tablet; }
    else if (w > bp.mobile && mobileLargeB != null)  { chosen = mobileLargeB!;  type = ResKitLayoutType.mobileLarge; }
    else                          { chosen = mobileB;                            type = ResKitLayoutType.mobile; }

    onLayout?.call(ResKitLayoutInfo(
      layoutType: type, screenWidth: w,
      screenHeight: MediaQuery.of(context).size.height,
      activeDesign: ResKit.activeDesign,
      deviceType: ResKit.deviceType, isWeb: web,
    ));
    return chosen(context);
  }
}

// ── Supporting types ─────────────────────────────────────────────────────────
enum ResKitDeviceType { mobile, tablet, desktop }

enum ResKitLayoutType {
  mobile, mobileLarge, tabletSmall, tablet, tabletLarge,
  desktop, desktopLarge, desktopXL, web,
}

class ResKitLayoutInfo {
  const ResKitLayoutInfo({
    required this.layoutType, required this.screenWidth,
    required this.screenHeight, required this.activeDesign,
    required this.deviceType, required this.isWeb,
  });
  final ResKitLayoutType  layoutType;
  final double            screenWidth;
  final double            screenHeight;
  final ResKitDesignSize  activeDesign;
  final ResKitDeviceType  deviceType;
  final bool              isWeb;

  @override String toString() =>
    'ResKitLayoutInfo(layout:$layoutType screen:${screenWidth.toStringAsFixed(0)}×${screenHeight.toStringAsFixed(0)} design:$activeDesign)';
}
