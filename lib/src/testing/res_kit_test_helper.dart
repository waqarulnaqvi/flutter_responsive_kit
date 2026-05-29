import 'package:flutter/material.dart';
import '../core/res_kit.dart';
import '../core/res_kit_config.dart';
import '../core/responsive_kit_init.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common screen sizes for use in widget tests.
abstract final class ResKitTestSizes {
  static const iphoneSE       = Size(375,  667);
  static const iphone14       = Size(390,  844);
  static const iphone14Max    = Size(430,  932);
  static const androidNexus5  = Size(360,  640);
  static const androidPixel7  = Size(412,  915);
  static const ipadMini       = Size(768,  1024);
  static const ipadPro11      = Size(834,  1194);
  static const ipadPro12      = Size(1024, 1366);
  static const macbookAir     = Size(1440, 900);
  static const fullHD         = Size(1920, 1080);
  static const webBrowser     = Size(1280, 800);
  static const watch          = Size(162,  197);
}

/// Testing helper that initialises [ResKit] with a specific screen size.
///
/// ```dart
/// testWidgets('shows mobile layout', (tester) async {
///   await ResKitTestHelper.pumpWidget(
///     tester,
///     widget: MyScreen(),
///     size:   ResKitTestSizes.iphone14,
///   );
///   expect(find.text('Mobile'), findsOneWidget);
/// });
/// ```
abstract final class ResKitTestHelper {

  /// Pump [widget] with ResKit initialised at [size].
  static Future<void> pumpWidget(
    WidgetTester tester, {
    required Widget widget,
    Size size = ResKitTestSizes.iphone14,
    double devicePixelRatio = 3.0,
    ResKitConfig? config,
  }) async {
    tester.view.physicalSize = size * devicePixelRatio;
    tester.view.devicePixelRatio = devicePixelRatio;

    final cfg = config ?? ResKitConfig(
      figmaWidth: size.width, figmaHeight: size.height,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size, devicePixelRatio: devicePixelRatio),
        child: ResponsiveKit(
          config: cfg,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          ),
        ),
      ),
    );
  }

  /// Pump the same widget at multiple sizes and run [check] for each.
  ///
  /// ```dart
  /// await ResKitTestHelper.pumpAtSizes(tester,
  ///   widget: MyScreen(),
  ///   sizes: [ResKitTestSizes.iphone14, ResKitTestSizes.ipadMini],
  ///   check: (size) {
  ///     if (size.width <= 480) {
  ///       expect(find.byType(BottomNavigationBar), findsOneWidget);
  ///     } else {
  ///       expect(find.byType(NavigationRail), findsOneWidget);
  ///     }
  ///   },
  /// );
  /// ```
  static Future<void> pumpAtSizes(
    WidgetTester tester, {
    required Widget widget,
    required List<Size> sizes,
    required void Function(Size size) check,
    ResKitConfig? config,
  }) async {
    for (final size in sizes) {
      await pumpWidget(tester, widget: widget, size: size, config: config);
      check(size);
    }
  }

  /// Initialise ResKit without a widget tree (useful for unit tests).
  ///
  /// ```dart
  /// setUp(() => ResKitTestHelper.init(size: ResKitTestSizes.iphone14));
  /// test('width scales correctly', () {
  ///   expect(ResKit.width(390), closeTo(390, 0.01));
  /// });
  /// ```
  static void init({
    Size size = ResKitTestSizes.iphone14,
    double devicePixelRatio = 3.0,
    ResKitConfig? config,
  }) {
    ResKit.init(
      mediaQuery: MediaQueryData(size: size, devicePixelRatio: devicePixelRatio),
      config: config ?? ResKitConfig(figmaWidth: size.width, figmaHeight: size.height),
    );
  }

  /// Init at tablet size.
  static void initTablet() => init(size: ResKitTestSizes.ipadMini,
      config: ResKitConfig(figmaWidth: 768, figmaHeight: 1024));

  /// Init at desktop size.
  static void initDesktop() => init(size: ResKitTestSizes.macbookAir,
      config: ResKitConfig(figmaWidth: 1440, figmaHeight: 900));

  /// Init at mobile size (default).
  static void initMobile() => init(size: ResKitTestSizes.iphone14);
}
