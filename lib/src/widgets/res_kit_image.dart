import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';

/// Breakpoint-aware local asset image.
/// Shows the asset that matches the current screen size.
///
/// ```dart
/// ResKitImage(
///   mobile:  'assets/banner_mobile.png',
///   tablet:  'assets/banner_tablet.png',
///   desktop: 'assets/banner_desktop.png',
///   width: double.infinity,
///   fit: BoxFit.cover,
/// )
/// ```
class ResKitImage extends StatelessWidget {
  const ResKitImage({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.web,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.color,
    this.colorBlendMode,
  });

  final String mobile;
  final String? tablet;
  final String? desktop;
  final String? web;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final Color? color;
  final BlendMode? colorBlendMode;

  String get _resolved {
    if (ResKit.isWeb    && web     != null) return web!;
    if (ResKit.isDesktop && desktop != null) return desktop!;
    if (ResKit.isTablet  && tablet  != null) return tablet!;
    return mobile;
  }

  @override
  Widget build(BuildContext context) => Image.asset(
    _resolved,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    semanticLabel: semanticLabel,
    color: color,
    colorBlendMode: colorBlendMode,
  );
}

/// Breakpoint-aware network image.
///
/// ```dart
/// ResKitNetworkImage(
///   mobile:  'https://cdn.example.com/hero-mobile.jpg',
///   desktop: 'https://cdn.example.com/hero-desktop.jpg',
///   width: double.infinity,
///   height: 300.h,
/// )
/// ```
class ResKitNetworkImage extends StatelessWidget {
  const ResKitNetworkImage({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.web,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.headers,
  });

  final String mobile;
  final String? tablet;
  final String? desktop;
  final String? web;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final Map<String, String>? headers;

  String get _resolved {
    if (ResKit.isWeb     && web     != null) return web!;
    if (ResKit.isDesktop && desktop != null) return desktop!;
    if (ResKit.isTablet  && tablet  != null) return tablet!;
    return mobile;
  }

  @override
  Widget build(BuildContext context) => Image.network(
    _resolved,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    headers: headers,
  );
}

/// Breakpoint-aware background decoration image helper.
/// Returns a [DecorationImage] for use inside [BoxDecoration].
///
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     image: ResKitDecorationImage.resolve(
///       mobile:  'assets/bg_mobile.png',
///       desktop: 'assets/bg_desktop.png',
///       fit: BoxFit.cover,
///     ),
///   ),
/// )
/// ```
abstract final class ResKitDecorationImage {
  static DecorationImage resolve({
    required String mobile,
    String? tablet,
    String? desktop,
    String? web,
    BoxFit fit = BoxFit.cover,
    AlignmentGeometry alignment = Alignment.center,
    ColorFilter? colorFilter,
  }) {
    String src;
    if (ResKit.isWeb     && web     != null) src = web;
    else if (ResKit.isDesktop && desktop != null) src = desktop;
    else if (ResKit.isTablet  && tablet  != null) src = tablet;
    else src = mobile;

    return DecorationImage(
      image: AssetImage(src),
      fit: fit,
      alignment: alignment,
      colorFilter: colorFilter,
    );
  }
}
