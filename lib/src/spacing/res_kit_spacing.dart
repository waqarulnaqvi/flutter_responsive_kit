import '../core/res_kit.dart';

/// Adaptive spacing token system.
///
/// Every token is a Figma-scaled value that also adapts per breakpoint,
/// so spacing automatically increases on tablets and desktops.
///
/// ```dart
/// SizedBox(height: ResKitSpacing.md)  // 16 on mobile, 20 on tablet, 24 on desktop
/// Padding(padding: EdgeInsets.all(ResKitSpacing.lg))
/// ```
abstract final class ResKitSpacing {

  // ── Base values (Figma mobile canvas) ─────────────────────────────────
  static const double _xs2Base  = 2;
  static const double _xsBase   = 4;
  static const double _smBase   = 8;
  static const double _mdBase   = 16;
  static const double _lgBase   = 24;
  static const double _xlBase   = 32;
  static const double _xxlBase  = 48;
  static const double _xxxlBase = 64;

  // ── Breakpoint multipliers ────────────────────────────────────────────
  static double get _multiplier =>
    ResKit.isDesktopLarge ? 1.5 :
    ResKit.isDesktop       ? 1.25 :
    ResKit.isTablet        ? 1.125 : 1.0;

  static double _t(double base) => ResKit.radius(base) * _multiplier;

  // ── Token getters ─────────────────────────────────────────────────────
  /// 2dp — hairline separator, micro gap.
  static double get xs2  => _t(_xs2Base);

  /// 4dp — tight spacing between related elements.
  static double get xs   => _t(_xsBase);

  /// 8dp — standard small gap.
  static double get sm   => _t(_smBase);

  /// 16dp — standard medium gap (card padding, list item spacing).
  static double get md   => _t(_mdBase);

  /// 24dp — large gap (section spacing).
  static double get lg   => _t(_lgBase);

  /// 32dp — extra-large gap (between major sections).
  static double get xl   => _t(_xlBase);

  /// 48dp — section-level whitespace.
  static double get xxl  => _t(_xxlBase);

  /// 64dp — page-level whitespace.
  static double get xxxl => _t(_xxxlBase);

  // ── Aliases ───────────────────────────────────────────────────────────
  static double get tiny   => xs;
  static double get small  => sm;
  static double get medium => md;
  static double get large  => lg;
  static double get huge   => xl;

  // ── Raw (Figma only, no breakpoint multiplier) ────────────────────────
  static double get rawXs   => ResKit.radius(_xsBase);
  static double get rawSm   => ResKit.radius(_smBase);
  static double get rawMd   => ResKit.radius(_mdBase);
  static double get rawLg   => ResKit.radius(_lgBase);
  static double get rawXl   => ResKit.radius(_xlBase);

  // ── Custom ────────────────────────────────────────────────────────────
  /// Scale any Figma spacing value with the breakpoint multiplier.
  static double of(double figmaValue) => _t(figmaValue);

  /// Scale without breakpoint multiplier.
  static double raw(double figmaValue) => ResKit.radius(figmaValue);
}
