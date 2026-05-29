import 'package:flutter/foundation.dart';
import 'res_kit_os.dart';

abstract final class ResKitPlatform {
  static bool get isWeb     => kIsWeb;
  static bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS     => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isMacOS   => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  static bool get isWindows => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  static bool get isLinux   => !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
  static bool get isFuchsia => !kIsWeb && defaultTargetPlatform == TargetPlatform.fuchsia;
  static bool get isNativeMobile  => isAndroid || isIOS;
  static bool get isNativeDesktop => isMacOS || isWindows || isLinux;

  static ResKitOS get current {
    if (kIsWeb) return ResKitOS.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return ResKitOS.android;
      case TargetPlatform.iOS:     return ResKitOS.ios;
      case TargetPlatform.macOS:   return ResKitOS.macOS;
      case TargetPlatform.windows: return ResKitOS.windows;
      case TargetPlatform.linux:   return ResKitOS.linux;
      case TargetPlatform.fuchsia: return ResKitOS.fuchsia;
    }
  }

  static T select<T>({
    T? android, T? ios, T? web, T? macOS, T? windows, T? linux, T? fuchsia,
    required T fallback,
  }) {
    if (isWeb     && web     != null) return web;
    if (isAndroid && android != null) return android;
    if (isIOS     && ios     != null) return ios;
    if (isMacOS   && macOS   != null) return macOS;
    if (isWindows && windows != null) return windows;
    if (isLinux   && linux   != null) return linux;
    if (isFuchsia && fuchsia != null) return fuchsia;
    return fallback;
  }
}
