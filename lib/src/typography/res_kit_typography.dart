import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// Responsive typography scale.
///
/// Every method returns a [TextStyle] with a font size that scales from
/// the active Figma canvas **and** fluid-interpolates between mobile/desktop.
///
/// ```dart
/// Text('Hello', style: ResKitTypography.h1())
/// Text('Body',  style: ResKitTypography.body())
/// Text('Small', style: ResKitTypography.caption())
/// ```
///
/// Override any property:
/// ```dart
/// ResKitTypography.h2(color: Colors.blue, fontWeight: FontWeight.w400)
/// ```
abstract final class ResKitTypography {

  // ── Base scale (matches 390-wide Figma / Material 3) ──────────────────
  static const double _h1Base     = 32;
  static const double _h2Base     = 28;
  static const double _h3Base     = 24;
  static const double _h4Base     = 20;
  static const double _h5Base     = 18;
  static const double _h6Base     = 16;
  static const double _titleLarge = 22;
  static const double _titleMed   = 16;
  static const double _titleSmall = 14;
  static const double _bodyLarge  = 16;
  static const double _bodyMed    = 14;
  static const double _bodySmall  = 12;
  static const double _labelLarge = 14;
  static const double _labelMed   = 12;
  static const double _labelSmall = 11;
  static const double _caption    = 12;
  static const double _overline   = 10;
  static const double _display    = 48;
  static const double _displaySm  = 36;

  // ── Internal helpers ──────────────────────────────────────────────────
  static double _fs(double base) => ResKit.sp(base);

  static TextStyle _style(
      double base, {
        FontWeight? fontWeight,
        Color? color,
        double? letterSpacing,
        double? height,
        String? fontFamily,
        TextDecoration? decoration,
        List<Shadow>? shadows,
        FontStyle? fontStyle,
      }) => TextStyle(
    fontSize:      _fs(base),
    fontWeight:    fontWeight,
    color:         color,
    letterSpacing: letterSpacing != null ? ResKit.sp(letterSpacing) : null,
    height:        height,
    fontFamily:    fontFamily,
    decoration:    decoration,
    shadows:       shadows,
    fontStyle:     fontStyle,
  );

  // ── Display ───────────────────────────────────────────────────────────
  static TextStyle display({FontWeight fw = FontWeight.w800, Color? color,
    double? letterSpacing, double height = 1.1, String? fontFamily}) =>
      _style(_display, fontWeight: fw, color: color,
          letterSpacing: letterSpacing ?? -1.5, height: height, fontFamily: fontFamily);

  static TextStyle displaySmall({FontWeight fw = FontWeight.w700, Color? color,
    double height = 1.1, String? fontFamily}) =>
      _style(_displaySm, fontWeight: fw, color: color,
          letterSpacing: -1.0, height: height, fontFamily: fontFamily);

  // ── Headings ──────────────────────────────────────────────────────────
  static TextStyle h1({FontWeight fw = FontWeight.w700, Color? color,
    double? letterSpacing, double height = 1.2, String? fontFamily}) =>
      _style(_h1Base, fontWeight: fw, color: color,
          letterSpacing: letterSpacing ?? -0.5, height: height, fontFamily: fontFamily);

  static TextStyle h2({FontWeight fw = FontWeight.w700, Color? color,
    double? letterSpacing, double height = 1.25, String? fontFamily}) =>
      _style(_h2Base, fontWeight: fw, color: color,
          letterSpacing: letterSpacing ?? -0.25, height: height, fontFamily: fontFamily);

  static TextStyle h3({FontWeight fw = FontWeight.w600, Color? color,
    double height = 1.3, String? fontFamily}) =>
      _style(_h3Base, fontWeight: fw, color: color, height: height, fontFamily: fontFamily);

  static TextStyle h4({FontWeight fw = FontWeight.w600, Color? color,
    double height = 1.35, String? fontFamily}) =>
      _style(_h4Base, fontWeight: fw, color: color, height: height, fontFamily: fontFamily);

  static TextStyle h5({FontWeight fw = FontWeight.w600, Color? color,
    double height = 1.4, String? fontFamily}) =>
      _style(_h5Base, fontWeight: fw, color: color, height: height, fontFamily: fontFamily);

  static TextStyle h6({FontWeight fw = FontWeight.w600, Color? color,
    double height = 1.4, String? fontFamily}) =>
      _style(_h6Base, fontWeight: fw, color: color, height: height, fontFamily: fontFamily);

  // ── Title ─────────────────────────────────────────────────────────────
  static TextStyle titleLarge({FontWeight fw = FontWeight.w500, Color? color, String? fontFamily}) =>
      _style(_titleLarge, fontWeight: fw, color: color, height: 1.4, fontFamily: fontFamily);

  static TextStyle titleMedium({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 0.15, String? fontFamily}) =>
      _style(_titleMed, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.4, fontFamily: fontFamily);

  static TextStyle titleSmall({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 0.1, String? fontFamily}) =>
      _style(_titleSmall, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.4, fontFamily: fontFamily);

  // ── Body ──────────────────────────────────────────────────────────────
  static TextStyle bodyLarge({FontWeight fw = FontWeight.w400, Color? color,
    double letterSpacing = 0.5, double height = 1.5, String? fontFamily}) =>
      _style(_bodyLarge, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: height, fontFamily: fontFamily);

  static TextStyle body({FontWeight fw = FontWeight.w400, Color? color,
    double letterSpacing = 0.25, double height = 1.5, String? fontFamily}) =>
      _style(_bodyMed, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: height, fontFamily: fontFamily);

  static TextStyle bodySmall({FontWeight fw = FontWeight.w400, Color? color,
    double letterSpacing = 0.4, double height = 1.5, String? fontFamily}) =>
      _style(_bodySmall, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: height, fontFamily: fontFamily);

  // ── Label ─────────────────────────────────────────────────────────────
  static TextStyle labelLarge({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 0.1, String? fontFamily}) =>
      _style(_labelLarge, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.4, fontFamily: fontFamily);

  static TextStyle label({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 0.5, String? fontFamily}) =>
      _style(_labelMed, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.4, fontFamily: fontFamily);

  static TextStyle labelSmall({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 0.5, String? fontFamily}) =>
      _style(_labelSmall, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.6, fontFamily: fontFamily);

  // ── Utility ───────────────────────────────────────────────────────────
  static TextStyle caption({FontWeight fw = FontWeight.w400, Color? color,
    double letterSpacing = 0.4, String? fontFamily}) =>
      _style(_caption, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.6, fontFamily: fontFamily);

  static TextStyle overline({FontWeight fw = FontWeight.w500, Color? color,
    double letterSpacing = 1.5, String? fontFamily}) =>
      _style(_overline, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.6, fontFamily: fontFamily)
          .copyWith(decoration: TextDecoration.none);

  // ── Button ────────────────────────────────────────────────────────────
  static TextStyle button({FontWeight fw = FontWeight.w600, Color? color,
    double letterSpacing = 0.5, String? fontFamily}) =>
      _style(_labelLarge, fontWeight: fw, color: color,
          letterSpacing: letterSpacing, height: 1.4, fontFamily: fontFamily);

  // ── Custom ────────────────────────────────────────────────────────────
  static TextStyle custom(double figmaSize, {
    FontWeight? fontWeight, Color? color, double? letterSpacing,
    double? height, String? fontFamily, TextDecoration? decoration,
    FontStyle? fontStyle,
  }) => _style(figmaSize, fontWeight: fontWeight, color: color,
      letterSpacing: letterSpacing, height: height,
      fontFamily: fontFamily, decoration: decoration, fontStyle: fontStyle);

  // ── Fluid ─────────────────────────────────────────────────────────────
  static TextStyle fluid({
    required double minSp, required double maxSp,
    FontWeight? fontWeight, Color? color, double? height,
  }) => TextStyle(
    fontSize:   ResKit.fluidSp(minSp: minSp, maxSp: maxSp),
    fontWeight: fontWeight,
    color:      color,
    height:     height,
  );

  // ── Adaptive ─────────────────────────────────────────────────────────
  static TextStyle adaptive({
    required TextStyle mobile, TextStyle? tablet, TextStyle? desktop,
  }) => ResKit.adaptive(mobile: mobile, tablet: tablet, desktop: desktop);
}
