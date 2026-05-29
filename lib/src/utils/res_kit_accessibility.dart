import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// Accessibility-aware helpers.
///
/// ```dart
/// // Use reduced-motion aware animation duration
/// duration: ResKitAccessibility.duration(const Duration(milliseconds: 300))
///
/// // Conditionally animate
/// if (!ResKitAccessibility.reducedMotion) { ... }
/// ```
abstract final class ResKitAccessibility {

  /// `true` when the user has enabled "Reduce Motion" in OS settings.
  static bool get reducedMotion     => ResKit.reducedMotion;

  /// `true` when high-contrast mode is active.
  static bool get highContrast      => ResKit.highContrast;

  /// `true` when bold text is enabled.
  static bool get boldText          => ResKit.boldText;

  /// `true` when colour inversion is active.
  static bool get invertColors      => ResKit.invertColors;

  /// `true` when accessible navigation is active.
  static bool get accessibleNav     => ResKit.accessibleNavigation;

  /// System text scale factor (1.0 = default).
  static double get textScaleFactor => ResKit.systemTextScaleFactor;

  /// Returns [duration] when animations are enabled, [Duration.zero] otherwise.
  ///
  /// ```dart
  /// AnimatedContainer(
  ///   duration: ResKitAccessibility.duration(Duration(milliseconds: 250)),
  /// )
  /// ```
  static Duration duration(Duration preferred) =>
      reducedMotion ? Duration.zero : preferred;

  /// Returns [curve] when animations are enabled, [Curves.linear] otherwise.
  static Curve curve(Curve preferred) =>
      reducedMotion ? Curves.linear : preferred;

  /// Minimum tap target size per accessibility guidelines (48dp).
  static double get minTapTarget => ResKit.radius(48);

  /// Wraps [child] in a [Semantics] widget with all provided labels.
  static Widget semantics({
    required Widget child,
    String? label,
    String? hint,
    String? value,
    bool button = false,
    bool header = false,
    bool image  = false,
    bool link   = false,
    VoidCallback? onTap,
  }) => Semantics(
    label:  label,
    hint:   hint,
    value:  value,
    button: button,
    header: header,
    image:  image,
    link:   link,
    onTap:  onTap,
    child:  child,
  );

  /// Ensure a widget meets the minimum 48dp tap target size.
  static Widget ensureTapTarget({required Widget child}) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:  minTapTarget,
          minHeight: minTapTarget,
        ),
        child: child,
      );
}
