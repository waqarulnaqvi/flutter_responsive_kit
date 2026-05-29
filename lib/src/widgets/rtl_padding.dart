import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// RTL-aware padding that automatically flips start/end in RTL layouts.
///
/// ```dart
/// ResKitRTLPadding(
///   start:  16,  // left in LTR, right in RTL
///   end:    8,   // right in LTR, left in RTL
///   top:    12,
///   bottom: 12,
///   child: Text('Hello'),
/// )
/// ```
class ResKitRTLPadding extends StatelessWidget {
  const ResKitRTLPadding({
    super.key,
    required this.child,
    this.start  = 0,
    this.end    = 0,
    this.top    = 0,
    this.bottom = 0,
    this.all,
    this.horizontal,
    this.vertical,
  });

  final Widget child;
  final num start;
  final num end;
  final num top;
  final num bottom;

  /// Overrides all four sides when set.
  final num? all;

  /// Overrides start + end when set.
  final num? horizontal;

  /// Overrides top + bottom when set.
  final num? vertical;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsDirectional padding;
    if (all != null) {
      padding = EdgeInsetsDirectional.all(ResKit.radius(all!));
    } else {
      final h = horizontal;
      final v = vertical;
      padding = EdgeInsetsDirectional.only(
        start:  ResKit.width(h ?? start),
        end:    ResKit.width(h ?? end),
        top:    ResKit.height(v ?? top),
        bottom: ResKit.height(v ?? bottom),
      );
    }
    return Padding(padding: padding, child: child);
  }
}

/// RTL-aware [SizedBox]-based gap.
/// Creates horizontal space that optionally flips in RTL.
class ResKitDirectionalGap extends StatelessWidget {
  const ResKitDirectionalGap(this.figmaWidth, {super.key});
  final double figmaWidth;
  @override
  Widget build(BuildContext context) =>
      SizedBox(width: ResKit.width(figmaWidth));
}
