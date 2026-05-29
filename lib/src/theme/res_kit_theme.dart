import 'package:flutter/material.dart';
import '../core/res_kit.dart';
import '../typography/res_kit_text_theme.dart';
import '../spacing/res_kit_spacing.dart';

/// Builds a fully scaled [ThemeData] from the active Figma canvas.
/// Every dimension — radii, icon sizes, dense settings, text sizes —
/// is derived from [ResKit] scale factors.
///
/// ```dart
/// MaterialApp(
///   theme: ResKitThemeData.build(
///     colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
///   ),
/// )
/// ```
abstract final class ResKitThemeData {

  /// Build a complete [ThemeData] with all ResKit tokens applied.
  static ThemeData build({
    required ColorScheme colorScheme,
    String? fontFamily,
    ThemeData? base,
  }) {
    final tt    = ResKitTextTheme.build(fontFamily: fontFamily);
    final r4    = ResKit.radius(4);
    final r8    = ResKit.radius(8);
    final r12   = ResKit.radius(12);
    final r16   = ResKit.radius(16);
    final r28   = ResKit.radius(28);

    return ThemeData(
      useMaterial3:  true,
      colorScheme:   colorScheme,
      fontFamily:    fontFamily,
      textTheme:     tt,
      // ── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        elevation:  0,
        scrolledUnderElevation: 1,
        titleTextStyle: tt.titleLarge,
        toolbarHeight: ResKit.height(56),
        iconTheme: IconThemeData(size: ResKit.radius(24)),
      ),
      // ── Cards ─────────────────────────────────────────────────────────
      // FIX: Changed from CardTheme to CardThemeData
      cardTheme: CardThemeData(
        elevation: ResKit.isDesktop ? 1 : 2,
        margin:    EdgeInsets.all(ResKitSpacing.xs),
        shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
      ),
      // ── Buttons ───────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle:     tt.labelLarge,
          minimumSize:   Size(ResKit.width(88), ResKit.height(44)),
          padding:       EdgeInsets.symmetric(
              horizontal: ResKitSpacing.lg, vertical: ResKitSpacing.sm),
          shape:         RoundedRectangleBorder(borderRadius: BorderRadius.circular(r8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle:   tt.labelLarge,
          minimumSize: Size(ResKit.width(88), ResKit.height(44)),
          padding:     EdgeInsets.symmetric(
              horizontal: ResKitSpacing.lg, vertical: ResKitSpacing.sm),
          shape:       RoundedRectangleBorder(borderRadius: BorderRadius.circular(r8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: tt.labelLarge,
          padding:   EdgeInsets.symmetric(
              horizontal: ResKitSpacing.md, vertical: ResKitSpacing.xs),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle:   tt.labelLarge,
          minimumSize: Size(ResKit.width(88), ResKit.height(44)),
          padding:     EdgeInsets.symmetric(
              horizontal: ResKitSpacing.lg, vertical: ResKitSpacing.sm),
          shape:         RoundedRectangleBorder(borderRadius: BorderRadius.circular(r28)),
        ),
      ),
      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            horizontal: ResKitSpacing.md, vertical: ResKitSpacing.md),
        border:         OutlineInputBorder(borderRadius: BorderRadius.circular(r8)),
        filled:         true,
        isDense:        ResKit.isDesktop,
      ),
      // ── Chips ─────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(r8)),
        padding: EdgeInsets.symmetric(
            horizontal: ResKitSpacing.sm, vertical: ResKitSpacing.xs2),
        labelStyle: tt.labelMedium,
      ),
      // ── Dialog ────────────────────────────────────────────────────────
      // FIX: Changed from DialogTheme to DialogThemeData
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
        titleTextStyle: tt.headlineSmall,
        contentTextStyle: tt.bodyMedium,
      ),
      // ── Bottom sheet ──────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(r16)),
        ),
      ),
      // ── Navigation ────────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle:   tt.labelSmall,
        unselectedLabelStyle: tt.labelSmall,
        selectedIconTheme:    IconThemeData(size: ResKit.radius(24)),
        unselectedIconTheme:  IconThemeData(size: ResKit.radius(22)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedLabelTextStyle:   tt.labelMedium,
        unselectedLabelTextStyle: tt.labelSmall,
        selectedIconTheme:  IconThemeData(size: ResKit.radius(24)),
        unselectedIconTheme:IconThemeData(size: ResKit.radius(22)),
        minWidth:     ResKit.width(72),
        minExtendedWidth: ResKit.width(200),
      ),
      // ── List tiles ────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
            horizontal: ResKitSpacing.md, vertical: ResKitSpacing.xs2),
        minLeadingWidth: ResKit.width(24),
        dense: ResKit.isDesktop,
      ),
      // ── Icon ──────────────────────────────────────────────────────────
      iconTheme: IconThemeData(size: ResKit.radius(24)),
      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: ResKitSpacing.md,
      ),
      // ── Snackbar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r8)),
        behavior: ResKit.isDesktop
            ? SnackBarBehavior.floating
            : SnackBarBehavior.fixed,
        contentTextStyle: tt.bodyMedium,
      ),
      // ── Tooltip ───────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        textStyle: tt.bodySmall,
        padding: EdgeInsets.symmetric(
            horizontal: ResKitSpacing.sm, vertical: ResKitSpacing.xs),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(r4)),
      ),
      // ── FloatingActionButton ──────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        sizeConstraints: BoxConstraints.tightFor(
          width:  ResKit.width(56),
          height: ResKit.height(56),
        ),
        iconSize:  ResKit.radius(24),
        shape:     RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
      ),
    );
  }

  /// Build for dark mode.
  static ThemeData buildDark({required ColorScheme colorScheme, String? fontFamily}) =>
      build(colorScheme: colorScheme, fontFamily: fontFamily);
}

/// InheritedWidget exposing [ResKitThemeData] to the subtree.
/// Access via `ResKitTheme.of(context)`.
class ResKitTheme extends InheritedWidget {
  const ResKitTheme({super.key, required super.child, required this.data});

  final ResKitThemeExtension data;

  static ResKitThemeExtension? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ResKitTheme>()?.data;

  static ResKitThemeExtension of(BuildContext context) {
    final t = maybeOf(context);
    assert(t != null, 'No ResKitTheme found in context.');
    return t!;
  }

  @override bool updateShouldNotify(ResKitTheme old) => old.data != data;
}

/// Custom theme extension with app-level design tokens.
///
/// Register with [ThemeData.extensions] for full Material 3 integration:
/// ```dart
/// ThemeData(extensions: [ResKitThemeExtension.light()])
/// // Access: Theme.of(context).extension<ResKitThemeExtension>()
/// ```
class ResKitThemeExtension extends ThemeExtension<ResKitThemeExtension> {
  const ResKitThemeExtension({
    this.cardRadius,
    this.buttonRadius,
    this.inputRadius,
    this.pageHorizontalPadding,
    this.sectionSpacing,
  });

  final double? cardRadius;
  final double? buttonRadius;
  final double? inputRadius;
  final double? pageHorizontalPadding;
  final double? sectionSpacing;

  factory ResKitThemeExtension.fromResKit() => ResKitThemeExtension(
    cardRadius:            ResKit.radius(12),
    buttonRadius:          ResKit.radius(8),
    inputRadius:           ResKit.radius(8),
    pageHorizontalPadding: ResKit.adaptive(
        mobile: ResKit.width(16), tablet: ResKit.width(24), desktop: ResKit.width(40)),
    sectionSpacing:        ResKitSpacing.xl,
  );

  @override
  ResKitThemeExtension copyWith({
    double? cardRadius, double? buttonRadius, double? inputRadius,
    double? pageHorizontalPadding, double? sectionSpacing,
  }) => ResKitThemeExtension(
    cardRadius: cardRadius ?? this.cardRadius,
    buttonRadius: buttonRadius ?? this.buttonRadius,
    inputRadius: inputRadius ?? this.inputRadius,
    pageHorizontalPadding: pageHorizontalPadding ?? this.pageHorizontalPadding,
    sectionSpacing: sectionSpacing ?? this.sectionSpacing,
  );

  @override
  ResKitThemeExtension lerp(ResKitThemeExtension? other, double t) {
    if (other == null) return this;
    return ResKitThemeExtension(
      cardRadius:            _lerpDouble(cardRadius, other.cardRadius, t),
      buttonRadius:          _lerpDouble(buttonRadius, other.buttonRadius, t),
      inputRadius:           _lerpDouble(inputRadius, other.inputRadius, t),
      pageHorizontalPadding: _lerpDouble(pageHorizontalPadding, other.pageHorizontalPadding, t),
      sectionSpacing:        _lerpDouble(sectionSpacing, other.sectionSpacing, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}
