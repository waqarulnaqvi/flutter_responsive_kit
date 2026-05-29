import 'package:flutter/widgets.dart';
import '../core/res_kit.dart';
import '../platform/res_kit_platform.dart';

// ── ResponsiveBuilder ────────────────────────────────────────────────────────

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key, required this.builder,
    this.mobileMaxWidth, this.tabletMaxWidth,
  });
  final Widget Function(BuildContext, BoxConstraints, ResKitDeviceType) builder;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;

  @override
  Widget build(BuildContext context) {
    final bp = ResKit.breakpoints;
    return LayoutBuilder(builder: (ctx, constraints) {
      final w = constraints.maxWidth;
      final mobileMax = mobileMaxWidth ?? bp.mobileLarge;
      final tabletMax = tabletMaxWidth ?? bp.tabletLarge;
      final type = w <= mobileMax
          ? ResKitDeviceType.mobile
          : w <= tabletMax
              ? ResKitDeviceType.tablet
              : ResKitDeviceType.desktop;
      return builder(ctx, constraints, type);
    });
  }
}

class TriStateResponsiveBuilder extends StatelessWidget {
  const TriStateResponsiveBuilder({
    super.key, required this.mobile,
    this.tablet, this.desktop,
    this.mobileMaxWidth, this.tabletMaxWidth,
  });
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double? mobileMaxWidth;
  final double? tabletMaxWidth;

  @override
  Widget build(BuildContext context) => ResponsiveBuilder(
    mobileMaxWidth: mobileMaxWidth,
    tabletMaxWidth: tabletMaxWidth,
    builder: (_, __, type) => switch (type) {
      ResKitDeviceType.desktop => desktop ?? tablet ?? mobile,
      ResKitDeviceType.tablet  => tablet  ?? mobile,
      ResKitDeviceType.mobile  => mobile,
    },
  );
}

// ── AdaptiveBuilder ──────────────────────────────────────────────────────────

class AdaptiveBuilder extends StatelessWidget {
  const AdaptiveBuilder({
    super.key, required this.fallback,
    this.android, this.ios, this.web,
    this.macOS, this.windows, this.linux, this.fuchsia,
    this.nativeMobile, this.nativeDesktop,
  });
  final Widget fallback;
  final Widget? android, ios, web, macOS, windows, linux, fuchsia;
  final Widget? nativeMobile, nativeDesktop;

  @override
  Widget build(BuildContext context) {
    if (ResKitPlatform.isWeb)     return web ?? fallback;
    if (ResKitPlatform.isAndroid) return android ?? nativeMobile ?? fallback;
    if (ResKitPlatform.isIOS)     return ios     ?? nativeMobile ?? fallback;
    if (ResKitPlatform.isMacOS)   return macOS   ?? nativeDesktop ?? fallback;
    if (ResKitPlatform.isWindows) return windows ?? nativeDesktop ?? fallback;
    if (ResKitPlatform.isLinux)   return linux   ?? nativeDesktop ?? fallback;
    if (ResKitPlatform.isFuchsia) return fuchsia ?? fallback;
    return fallback;
  }
}

class AdaptiveBuilderFn extends StatelessWidget {
  const AdaptiveBuilderFn({super.key, required this.builder});
  final Widget Function(BuildContext, TargetPlatformInfo) builder;
  @override
  Widget build(BuildContext context) => builder(context, TargetPlatformInfo(
    isAndroid: ResKitPlatform.isAndroid, isIOS: ResKitPlatform.isIOS,
    isWeb: ResKitPlatform.isWeb, isMacOS: ResKitPlatform.isMacOS,
    isWindows: ResKitPlatform.isWindows, isLinux: ResKitPlatform.isLinux,
    isFuchsia: ResKitPlatform.isFuchsia,
    isNativeMobile: ResKitPlatform.isNativeMobile,
    isNativeDesktop: ResKitPlatform.isNativeDesktop,
  ));
}

final class TargetPlatformInfo {
  const TargetPlatformInfo({
    required this.isAndroid, required this.isIOS, required this.isWeb,
    required this.isMacOS, required this.isWindows, required this.isLinux,
    required this.isFuchsia, required this.isNativeMobile, required this.isNativeDesktop,
  });
  final bool isAndroid, isIOS, isWeb, isMacOS, isWindows, isLinux,
             isFuchsia, isNativeMobile, isNativeDesktop;
}

// ── WebContentWrapper ────────────────────────────────────────────────────────

class WebContentWrapper extends StatelessWidget {
  const WebContentWrapper({
    super.key, required this.child,
    this.maxWidth, this.alignment = Alignment.topCenter, this.padding,
  });
  final Widget child;
  final double? maxWidth;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final max = maxWidth ?? ResKit.breakpoints.webMaxContent;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

// ── ResponsiveVisibility ─────────────────────────────────────────────────────

class ResponsiveVisibility extends StatelessWidget {
  const ResponsiveVisibility({
    super.key, required this.condition, required this.child,
    this.fallback, this.maintainState = false,
  });
  final bool condition;
  final Widget child;
  final Widget? fallback;
  final bool maintainState;

  @override
  Widget build(BuildContext context) {
    if (maintainState) return Visibility(visible: condition, maintainState: true, child: child);
    return condition ? child : (fallback ?? const SizedBox.shrink());
  }
}

// ── ResKitMediaQuery ─────────────────────────────────────────────────────────

class ResKitMediaQuery extends StatelessWidget {
  const ResKitMediaQuery({
    super.key, required this.child, this.size, this.devicePixelRatio,
    this.textScaleFactor, this.padding, this.viewInsets,
    this.platformBrightness,
  });
  final Widget child;
  final Size? size;
  final double? devicePixelRatio;
  final double? textScaleFactor;
  final EdgeInsets? padding;
  final EdgeInsets? viewInsets;
  final Brightness? platformBrightness;

  @override
  Widget build(BuildContext context) {
    final base = MediaQuery.of(context);
    return MediaQuery(
      data: base.copyWith(
        size: size ?? base.size,
        devicePixelRatio: devicePixelRatio ?? base.devicePixelRatio,
        textScaler: textScaleFactor != null
            ? TextScaler.linear(textScaleFactor!)
            : base.textScaler,
        padding: padding ?? base.padding,
        viewInsets: viewInsets ?? base.viewInsets,
        platformBrightness: platformBrightness ?? base.platformBrightness,
      ),
      child: child,
    );
  }
}
