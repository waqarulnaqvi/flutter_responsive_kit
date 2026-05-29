import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';
import 'res_kit_spacing.dart';

/// Ready-made [EdgeInsets] presets using the spacing token system.
///
/// ```dart
/// Padding(padding: ResKitInsets.pagePadding)
/// Padding(padding: ResKitInsets.cardPadding)
/// Padding(padding: ResKitInsets.inputPadding)
/// ```
abstract final class ResKitInsets {

  // ── Page / screen ─────────────────────────────────────────────────────
  /// Standard page padding. Increases on larger screens.
  static EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: ResKit.adaptive(
      mobile: ResKit.width(16), tablet: ResKit.width(24), desktop: ResKit.width(40)),
    vertical: ResKit.height(16),
  );

  /// Horizontal page padding only.
  static EdgeInsets get pageHorizontal => EdgeInsets.symmetric(
    horizontal: ResKit.adaptive(
      mobile: ResKit.width(16), tablet: ResKit.width(24), desktop: ResKit.width(40)),
  );

  // ── Cards ─────────────────────────────────────────────────────────────
  /// Standard card content padding.
  static EdgeInsets get cardPadding =>
      EdgeInsets.all(ResKitSpacing.md);

  /// Compact card padding.
  static EdgeInsets get cardPaddingSmall =>
      EdgeInsets.all(ResKitSpacing.sm);

  /// Spacious card padding (for desktop).
  static EdgeInsets get cardPaddingLarge =>
      EdgeInsets.all(ResKitSpacing.lg);

  // ── List tiles ────────────────────────────────────────────────────────
  static EdgeInsets get listTilePadding => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.md, vertical: ResKitSpacing.sm,
  );

  // ── Buttons ───────────────────────────────────────────────────────────
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.lg, vertical: ResKitSpacing.sm,
  );

  static EdgeInsets get buttonPaddingSmall => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.md, vertical: ResKitSpacing.xs,
  );

  static EdgeInsets get buttonPaddingLarge => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.xxl, vertical: ResKitSpacing.md,
  );

  // ── Inputs ────────────────────────────────────────────────────────────
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.md, vertical: ResKitSpacing.md,
  );

  // ── Dialogs ───────────────────────────────────────────────────────────
  static EdgeInsets get dialogPadding =>
      EdgeInsets.all(ResKitSpacing.xl);

  // ── Bottom sheets ─────────────────────────────────────────────────────
  static EdgeInsets get bottomSheetPadding => EdgeInsets.fromLTRB(
    ResKitSpacing.lg, ResKitSpacing.sm,
    ResKitSpacing.lg, ResKitSpacing.lg,
  );

  // ── AppBar ────────────────────────────────────────────────────────────
  static EdgeInsets get appBarPadding => EdgeInsets.symmetric(
    horizontal: ResKitSpacing.md,
  );

  // ── Section gaps ─────────────────────────────────────────────────────
  static SizedBox get gapXs   => SizedBox(height: ResKitSpacing.xs);
  static SizedBox get gapSm   => SizedBox(height: ResKitSpacing.sm);
  static SizedBox get gapMd   => SizedBox(height: ResKitSpacing.md);
  static SizedBox get gapLg   => SizedBox(height: ResKitSpacing.lg);
  static SizedBox get gapXl   => SizedBox(height: ResKitSpacing.xl);
  static SizedBox get gapXxl  => SizedBox(height: ResKitSpacing.xxl);
  static SizedBox get hGapXs  => SizedBox(width: ResKitSpacing.xs);
  static SizedBox get hGapSm  => SizedBox(width: ResKitSpacing.sm);
  static SizedBox get hGapMd  => SizedBox(width: ResKitSpacing.md);
  static SizedBox get hGapLg  => SizedBox(width: ResKitSpacing.lg);
}
