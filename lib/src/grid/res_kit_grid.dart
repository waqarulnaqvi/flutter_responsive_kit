import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';
import '../spacing/res_kit_spacing.dart';

/// A 12-column responsive grid that mirrors Figma / Bootstrap / Material 3
/// grid behaviour.
///
/// Each [ResKitGridItem] declares how many columns it spans at each breakpoint.
///
/// ```dart
/// ResKitGrid(
///   children: [
///     ResKitGridItem(
///       mobile: 12, tablet: 6, desktop: 4,
///       child: ProductCard(),
///     ),
///     ResKitGridItem(
///       mobile: 12, tablet: 6, desktop: 4,
///       child: ProductCard(),
///     ),
///   ],
/// )
/// ```
class ResKitGrid extends StatelessWidget {
  const ResKitGrid({
    super.key,
    required this.children,
    this.columns = 12,
    this.gutter,
    this.rowGap,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<ResKitGridItem> children;

  /// Total number of columns (default 12).
  final int columns;

  /// Horizontal gap between columns. Defaults to [ResKitSpacing.md].
  final double? gutter;

  /// Vertical gap between rows. Defaults to [ResKitSpacing.md].
  final double? rowGap;

  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final g   = gutter ?? ResKitSpacing.md;
    final rg  = rowGap  ?? ResKitSpacing.md;

    // Build rows by accumulating column spans
    final rows   = <List<ResKitGridItem>>[];
    var   current = <ResKitGridItem>[];
    var   used    = 0;

    for (final item in children) {
      final span = item._resolveSpan(columns);
      if (used + span > columns && current.isNotEmpty) {
        rows.add(current);
        current = [];
        used    = 0;
      }
      current.add(item);
      used += span;
      if (used >= columns) {
        rows.add(current);
        current = [];
        used    = 0;
      }
    }
    if (current.isNotEmpty) rows.add(current);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(builder: (ctx, constraints) {
        final totalWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            for (var ri = 0; ri < rows.length; ri++) ...[
              Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  for (var ci = 0; ci < rows[ri].length; ci++) ...[
                    _buildCell(rows[ri][ci], totalWidth, g, columns),
                    if (ci < rows[ri].length - 1) SizedBox(width: g),
                  ],
                ],
              ),
              if (ri < rows.length - 1) SizedBox(height: rg),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildCell(ResKitGridItem item, double totalWidth, double gutter, int cols) {
    final span  = item._resolveSpan(cols);
    final width = (totalWidth + gutter) * (span / cols) - gutter;
    return SizedBox(width: width, child: item.child);
  }
}

/// A single cell inside [ResKitGrid].
class ResKitGridItem {
  const ResKitGridItem({
    required this.child,
    this.xs,
    this.mobile  = 12,
    this.tablet,
    this.desktop,
    this.desktopLarge,
  });

  final Widget child;

  /// Column span on extra-small screens (≤360). Defaults to [mobile].
  final int? xs;

  /// Column span on mobile screens. **Required** (default 12 = full width).
  final int mobile;

  /// Column span on tablet screens. Defaults to [mobile].
  final int? tablet;

  /// Column span on desktop screens. Defaults to [tablet] or [mobile].
  final int? desktop;

  /// Column span on large desktop screens. Defaults to [desktop].
  final int? desktopLarge;

  int _resolveSpan(int cols) {
    int span;
    if (ResKit.isDesktopLarge) {
      span = desktopLarge ?? desktop ?? tablet ?? mobile;
    } else if (ResKit.isDesktop) {
      span = desktop ?? tablet ?? mobile;
    } else if (ResKit.isTablet) {
      span = tablet ?? mobile;
    } else if (ResKit.isMobileSmall && xs != null) {
      span = xs!;
    } else {
      span = mobile;
    }
    return span.clamp(1, cols);
  }
}
