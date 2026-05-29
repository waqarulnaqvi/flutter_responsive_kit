import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

abstract final class ResKitUtils {

  // ── Grid math ─────────────────────────────────────────────────────────
  static double gridItemWidth({
    required int columns, double spacing = 0,
    double? availableWidth, double padding = 0,
  }) {
    final total = (availableWidth ?? ResKit.screenWidth) - padding * 2;
    return (total - spacing * (columns - 1)) / columns;
  }

  static int adaptiveColumns({
    required double minItemWidth, double spacing = 8,
    double? availableWidth, double padding = 0,
  }) {
    final total = (availableWidth ?? ResKit.screenWidth) - padding * 2;
    return math.max(1, ((total + spacing) ~/ (ResKit.width(minItemWidth) + spacing)));
  }

  // ── Text ─────────────────────────────────────────────────────────────
  static TextStyle textStyle(num figmaFontSize, {
    Color? color, FontWeight? fontWeight, String? fontFamily,
    double? height, double? letterSpacing, TextDecoration? decoration,
  }) => TextStyle(
    fontSize: ResKit.sp(figmaFontSize), color: color,
    fontWeight: fontWeight, fontFamily: fontFamily,
    height: height,
    letterSpacing: letterSpacing != null ? ResKit.sp(letterSpacing) : null,
    decoration: decoration,
  );

  // ── Aspect ratio ──────────────────────────────────────────────────────
  static Size aspectFitWidth({
    required num figmaWidth, required num figmaHeight, num? targetWidth,
  }) {
    final w = ResKit.width(targetWidth ?? figmaWidth);
    return Size(w, w * (figmaHeight / figmaWidth));
  }

  static Size aspectFitHeight({
    required num figmaWidth, required num figmaHeight, num? targetHeight,
  }) {
    final h = ResKit.height(targetHeight ?? figmaHeight);
    return Size(h * (figmaWidth / figmaHeight), h);
  }

  // ── Safe area ─────────────────────────────────────────────────────────
  static double get usableHeight =>
      ResKit.screenHeight - ResKit.statusBarHeight -
      ResKit.bottomBarHeight - ResKit.keyboardHeight;

  static double get usableWidth => ResKit.screenWidth;

  // ── Clamp ─────────────────────────────────────────────────────────────
  static double clampWidth(num v, {required num min, required num max}) =>
      ResKit.width(v).clamp(ResKit.width(min), ResKit.width(max));

  static double clampHeight(num v, {required num min, required num max}) =>
      ResKit.height(v).clamp(ResKit.height(min), ResKit.height(max));

  // ── Orientation ───────────────────────────────────────────────────────
  static T byOrientation<T>({required T portrait, required T landscape}) =>
      ResKit.isPortrait ? portrait : landscape;

  // ── Debug map ─────────────────────────────────────────────────────────
  static Map<String, dynamic> diagnosticMap() => {
    'screenWidth':    ResKit.screenWidth,
    'screenHeight':   ResKit.screenHeight,
    'devicePixelRatio': ResKit.devicePixelRatio,
    'scaleW':         ResKit.scaleW,
    'scaleH':         ResKit.scaleH,
    'scale':          ResKit.scale,
    'textScale':      ResKit.textScale,
    'figmaWidth':     ResKit.figmaWidth,
    'figmaHeight':    ResKit.figmaHeight,
    'activeDesign':   ResKit.activeDesign.toString(),
    'isPortrait':     ResKit.isPortrait,
    'isMobile':       ResKit.isMobile,
    'isTablet':       ResKit.isTablet,
    'isDesktop':      ResKit.isDesktop,
    'platform':       ResKit.platform.name,
    'statusBarHeight': ResKit.statusBarHeight,
    'bottomBarHeight': ResKit.bottomBarHeight,
    'reducedMotion':  ResKit.reducedMotion,
    'highContrast':   ResKit.highContrast,
  };
}
