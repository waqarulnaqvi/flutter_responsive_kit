import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';
import '../spacing/res_kit_spacing.dart';

/// Auto-flow grid: automatically fills rows with as many columns as fit,
/// given a minimum item width. Equivalent to CSS `grid-template-columns:
/// repeat(auto-fill, minmax(minItemWidth, 1fr))`.
///
/// ```dart
/// ResKitFlexGrid(
///   minItemWidth: 160,   // Figma px — at least 160dp wide per card
///   children: products.map((p) => ProductCard(p)).toList(),
/// )
/// ```
class ResKitFlexGrid extends StatelessWidget {
  const ResKitFlexGrid({
    super.key,
    required this.children,
    this.minItemWidth = 160,
    this.maxColumns,
    this.gutter,
    this.rowGap,
    this.padding,
    this.childAspectRatio,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;

  /// Minimum item width **in Figma logical pixels** (will be scaled).
  final double minItemWidth;

  /// Hard cap on number of columns. Null = no limit.
  final int? maxColumns;

  final double? gutter;
  final double? rowGap;
  final EdgeInsetsGeometry? padding;

  /// If set, wraps each child in an [AspectRatio].
  final double? childAspectRatio;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final g  = gutter ?? ResKitSpacing.md;
    final rg = rowGap  ?? ResKitSpacing.md;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(builder: (ctx, constraints) {
        final available = constraints.maxWidth;
        final minW = ResKit.width(minItemWidth);
        var cols = ((available + g) / (minW + g)).floor().clamp(1, 99);
        if (maxColumns != null) cols = cols.clamp(1, maxColumns!);
        final itemW = (available - g * (cols - 1)) / cols;

        final rows = <List<Widget>>[];
        for (var i = 0; i < children.length; i += cols) {
          rows.add(children.sublist(i, (i + cols).clamp(0, children.length)));
        }

        return Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            for (var ri = 0; ri < rows.length; ri++) ...[
              Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  for (var ci = 0; ci < rows[ri].length; ci++) ...[
                    SizedBox(
                      width: itemW,
                      child: childAspectRatio != null
                          ? AspectRatio(aspectRatio: childAspectRatio!, child: rows[ri][ci])
                          : rows[ri][ci],
                    ),
                    if (ci < rows[ri].length - 1) SizedBox(width: g),
                  ],
                  // Fill empty trailing cells
                  for (var fill = rows[ri].length; fill < cols; fill++) ...[
                    SizedBox(width: g),
                    SizedBox(width: itemW),
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
}
