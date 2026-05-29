import 'package:flutter/material.dart';
import '../core/res_kit.dart';
import 'res_kit_typography.dart';

/// Builds a fully scaled Flutter [TextTheme] from the active Figma canvas.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     textTheme: ResKitTextTheme.build(),
///     // or with a custom color:
///     textTheme: ResKitTextTheme.build(color: Colors.black87),
///   ),
/// )
/// ```
abstract final class ResKitTextTheme {
  static TextTheme build({
    Color? color,
    String? fontFamily,
    Color? displayColor,
    Color? bodyColor,
  }) {
    final dc = displayColor ?? color;
    final bc = bodyColor    ?? color;
    return TextTheme(
      displayLarge:   ResKitTypography.display(color: dc, fontFamily: fontFamily),
      displayMedium:  ResKitTypography.displaySmall(color: dc, fontFamily: fontFamily),
      displaySmall:   ResKitTypography.h1(color: dc, fontFamily: fontFamily),
      headlineLarge:  ResKitTypography.h2(color: dc, fontFamily: fontFamily),
      headlineMedium: ResKitTypography.h3(color: dc, fontFamily: fontFamily),
      headlineSmall:  ResKitTypography.h4(color: dc, fontFamily: fontFamily),
      titleLarge:     ResKitTypography.titleLarge(color: bc, fontFamily: fontFamily),
      titleMedium:    ResKitTypography.titleMedium(color: bc, fontFamily: fontFamily),
      titleSmall:     ResKitTypography.titleSmall(color: bc, fontFamily: fontFamily),
      bodyLarge:      ResKitTypography.bodyLarge(color: bc, fontFamily: fontFamily),
      bodyMedium:     ResKitTypography.body(color: bc, fontFamily: fontFamily),
      bodySmall:      ResKitTypography.bodySmall(color: bc, fontFamily: fontFamily),
      labelLarge:     ResKitTypography.labelLarge(color: bc, fontFamily: fontFamily),
      labelMedium:    ResKitTypography.label(color: bc, fontFamily: fontFamily),
      labelSmall:     ResKitTypography.labelSmall(color: bc, fontFamily: fontFamily),
    );
  }

  /// Merge ResKit scaling into an existing [TextTheme] — scales all font sizes
  /// without losing any existing colors, weights, or families.
  static TextTheme merge(TextTheme base) => TextTheme(
    displayLarge:   _scale(base.displayLarge),
    displayMedium:  _scale(base.displayMedium),
    displaySmall:   _scale(base.displaySmall),
    headlineLarge:  _scale(base.headlineLarge),
    headlineMedium: _scale(base.headlineMedium),
    headlineSmall:  _scale(base.headlineSmall),
    titleLarge:     _scale(base.titleLarge),
    titleMedium:    _scale(base.titleMedium),
    titleSmall:     _scale(base.titleSmall),
    bodyLarge:      _scale(base.bodyLarge),
    bodyMedium:     _scale(base.bodyMedium),
    bodySmall:      _scale(base.bodySmall),
    labelLarge:     _scale(base.labelLarge),
    labelMedium:    _scale(base.labelMedium),
    labelSmall:     _scale(base.labelSmall),
  );

  static TextStyle? _scale(TextStyle? s) {
    if (s == null) return null;
    final fs = s.fontSize;
    if (fs == null) return s;
    return s.copyWith(fontSize: ResKit.sp(fs));
  }
}
