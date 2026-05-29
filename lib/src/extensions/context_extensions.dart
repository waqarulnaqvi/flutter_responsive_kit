import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';
import '../core/res_kit_breakpoints.dart';
import '../core/res_kit_design_config.dart';
import '../platform/res_kit_platform.dart';
import '../platform/res_kit_os.dart';

extension ResKitContextExtension on BuildContext {
  // ── MediaQuery ──────────────────────────────────────────────────────
  MediaQueryData get mq              => MediaQuery.of(this);
  Size           get screenSize      => mq.size;
  double         get screenWidth     => mq.size.width;
  double         get screenHeight    => mq.size.height;
  double         get devicePixelRatio=> mq.devicePixelRatio;
  double         get statusBarHeight => mq.padding.top;
  double         get bottomBarHeight => mq.viewInsets.bottom + mq.padding.bottom;
  double         get keyboardHeight  => mq.viewInsets.bottom;
  bool           get isKeyboardOpen  => mq.viewInsets.bottom > 0;
  EdgeInsets     get safeAreaPadding => mq.padding;
  Brightness     get brightness      => mq.platformBrightness;
  bool           get isDarkMode      => mq.platformBrightness == Brightness.dark;

  // ── Scale ────────────────────────────────────────────────────────────
  double get scaleW     => ResKit.scaleW;
  double get scaleH     => ResKit.scaleH;
  double get scale      => ResKit.scale;
  double get textScale  => ResKit.textScale;
  double get figmaWidth => ResKit.figmaWidth;
  double get figmaHeight=> ResKit.figmaHeight;
  ResKitDesignSize get activeDesign => ResKit.activeDesign;

  // ── Sizing ───────────────────────────────────────────────────────────
  double width(num v)   => ResKit.width(v);
  double w(num v)       => ResKit.width(v);
  double height(num v)  => ResKit.height(v);
  double h(num v)       => ResKit.height(v);
  double radius(num v)  => ResKit.radius(v);
  double r(num v)       => ResKit.radius(v);
  double sp(num v)      => ResKit.sp(v);
  double dp(num v)      => ResKit.dp(v);
  double sw(double f)   => ResKit.sw(f);
  double sh(double f)   => ResKit.sh(f);

  double fluidSp({required double minSp, required double maxSp,
      double? minWidth, double? maxWidth}) =>
    ResKit.fluidSp(minSp: minSp, maxSp: maxSp,
        minWidth: minWidth, maxWidth: maxWidth);

  // ── Orientation ──────────────────────────────────────────────────────
  Orientation get orientation => mq.orientation;
  bool get isPortrait  => mq.orientation == Orientation.portrait;
  bool get isLandscape => mq.orientation == Orientation.landscape;

  // ── RTL ──────────────────────────────────────────────────────────────
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
  bool get isLTR => Directionality.of(this) == TextDirection.ltr;
  TextDirection get textDirection => Directionality.of(this);

  // ── Breakpoints ──────────────────────────────────────────────────────
  ResKitBreakpoints get breakpoints  => ResKit.breakpoints;
  bool get isMobileSmall  => ResKit.isMobileSmall;
  bool get isMobile       => ResKit.isMobile;
  bool get isMobileLarge  => ResKit.isMobileLarge;
  bool get isTabletSmall  => ResKit.isTabletSmall;
  bool get isTablet       => ResKit.isTablet;
  bool get isTabletLarge  => ResKit.isTabletLarge;
  bool get isDesktop      => ResKit.isDesktop;
  bool get isDesktopLarge => ResKit.isDesktopLarge;
  bool get isDesktopXL    => ResKit.isDesktopXL;
  ResKitDeviceType get deviceType => ResKit.deviceType;

  // ── Platform ─────────────────────────────────────────────────────────
  ResKitOS get platform       => ResKitPlatform.current;
  bool get isAndroid          => ResKitPlatform.isAndroid;
  bool get isIOS              => ResKitPlatform.isIOS;
  bool get isWeb              => ResKitPlatform.isWeb;
  bool get isMacOS            => ResKitPlatform.isMacOS;
  bool get isWindows          => ResKitPlatform.isWindows;
  bool get isLinux            => ResKitPlatform.isLinux;
  bool get isFuchsia          => ResKitPlatform.isFuchsia;
  bool get isNativeMobile     => ResKitPlatform.isNativeMobile;
  bool get isNativeDesktop    => ResKitPlatform.isNativeDesktop;

  // ── Accessibility ─────────────────────────────────────────────────────
  bool   get reducedMotion   => mq.disableAnimations;
  bool   get highContrast    => mq.highContrast;
  bool   get boldText        => mq.boldText;
  bool   get invertColors    => mq.invertColors;

  // ── Adaptive helpers ─────────────────────────────────────────────────
  T adaptive<T>({required T mobile, T? tablet, T? desktop}) =>
      ResKit.adaptive(mobile: mobile, tablet: tablet, desktop: desktop);

  T perPlatform<T>({T? android, T? ios, T? web, T? macOS,
      T? windows, T? linux, T? fuchsia, required T fallback}) =>
      ResKit.perPlatform(android: android, ios: ios, web: web,
          macOS: macOS, windows: windows, linux: linux,
          fuchsia: fuchsia, fallback: fallback);

  // ── responsiveBuilder shortcut ────────────────────────────────────────
  Widget responsiveBuilder({
    Widget? mobile, Widget? mobileLarge, Widget? tabletSmall,
    Widget? tablet, Widget? tabletLarge, Widget? desktop,
    Widget? desktopLarge, Widget? desktopXL, Widget? web,
    Widget Function(BuildContext)? mobileBuilder,
    Widget Function(BuildContext)? tabletBuilder,
    Widget Function(BuildContext)? desktopBuilder,
    Widget Function(BuildContext)? webBuilder,
    void Function(ResKitLayoutInfo)? onLayout,
  }) => ResKit.builder(
    mobile: mobile, mobileLarge: mobileLarge, tabletSmall: tabletSmall,
    tablet: tablet, tabletLarge: tabletLarge, desktop: desktop,
    desktopLarge: desktopLarge, desktopXL: desktopXL, web: web,
    mobileBuilder: mobileBuilder, tabletBuilder: tabletBuilder,
    desktopBuilder: desktopBuilder, webBuilder: webBuilder,
    onLayout: onLayout,
  );
}
