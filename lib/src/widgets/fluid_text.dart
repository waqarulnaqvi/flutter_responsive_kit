import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// A [Text] widget whose font size **fluidly interpolates** between [minSp]
/// and [maxSp] as the screen width grows from mobile to desktop.
///
/// Equivalent to CSS `font-size: clamp(minSp, vw, maxSp)`.
///
/// ```dart
/// FluidText(
///   'Responsive Heading',
///   minSp: 18,
///   maxSp: 36,
///   style: TextStyle(fontWeight: FontWeight.w700),
/// )
/// ```
class FluidText extends StatelessWidget {
  const FluidText(
    this.data, {
    super.key,
    required this.minSp,
    required this.maxSp,
    this.minWidth,
    this.maxWidth,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.semanticsLabel,
  });

  final String data;
  final double minSp;
  final double maxSp;
  final double? minWidth;
  final double? maxWidth;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final fs = ResKit.fluidSp(
      minSp: minSp, maxSp: maxSp,
      minWidth: minWidth, maxWidth: maxWidth,
    );
    return Text(
      data,
      semanticsLabel: semanticsLabel,
      textAlign:  textAlign,
      maxLines:   maxLines,
      overflow:   overflow,
      softWrap:   softWrap,
      style:      (style ?? const TextStyle()).copyWith(fontSize: fs),
    );
  }
}
