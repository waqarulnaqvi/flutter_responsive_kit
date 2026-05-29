# flutter_responsive_plus

> **The complete Flutter responsive & adaptive toolkit — v1.0.2** > Every pattern a production app needs. One package. One import.

[![pub version](https://img.shields.io/pub/v/flutter_responsive_plus.svg)](https://pub.dev/packages/flutter_responsive_plus)
[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## What's inside

| Module | What it gives you |
|---|---|
| **Core / Scaling** | Figma-to-device scaling, multi-canvas per breakpoint, `ResKit.*` global namespace |
| **`ResKit.builder()`** | 9-slot layout picker — `mobile / tablet / desktop / web / mobileLarge / tabletSmall / tabletLarge / desktopLarge / desktopXL` |
| **Typography** | Full type scale (display → overline), Flutter `TextTheme` builder, fluid text, adaptive styles |
| **Spacing** | 8 adaptive tokens that grow on larger screens, pre-built `EdgeInsets` presets |
| **Grid** | 12-column responsive grid + auto-flow flex grid |
| **Navigation** | Single widget auto-switches BottomNav → Rail → Drawer |
| **Images** | Breakpoint-aware local and network image switchers |
| **Theme** | Fully scaled `ThemeData` builder + `ThemeExtension` tokens |
| **Accessibility** | `reducedMotion`, `highContrast`, `boldText`, min tap targets, animation helpers |
| **RTL** | `directional()`, `ResKitRTLPadding`, `context.isRTL` |
| **Fluid Typography** | `fluidSp()` / `FluidText` — CSS `clamp()` equivalent |
| **Testing** | `ResKitTestHelper`, `ResKitTestSizes` — pump at any screen size in one line |
| **Extensions** | `.w .h .r .sp .sw .sh .dp` on `num`; 50+ getters on `BuildContext` |

---

## Installation

```yaml
dependencies:
  flutter_responsive_plus: ^1.0.2
```

```dart
import 'package:flutter_responsive_kit/flutter_responsive_kit.dart';
```

---

## 1. Setup

Wrap your `MaterialApp` once. That's it.

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      config: ResKitConfig(
        // ── Multi-canvas: one Figma frame per device category ──────────
        designs: ResKitDesignConfig(
          mobile:  ResKitDesignSize.iphone14,    // 390 × 844
          tablet:  ResKitDesignSize.ipadMini,     // 768 × 1024
          desktop: ResKitDesignSize.macbookAir,   // 1440 × 900
          web:     ResKitDesignSize.webBrowser,   // 1280 × 800
        ),
        maxFontScale: 1.3,
      ),
      child: MaterialApp(
        theme: ResKitThemeData.build(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: ResKit.builder(
          mobile:  (ctx) => MobileScreen(),
          tablet:  (ctx) => TabletScreen(),
          desktop: (ctx) => DesktopScreen(),
          web:     (ctx) => WebScreen(),
        ),
      ),
    );
  }
}
```

---

## 2. Figma Scaling

```dart
// Function style
ResKit.width(200)    // scale 200 from active Figma width
ResKit.height(100)   // scale 100 from active Figma height
ResKit.radius(12)    // uniform: min(scaleW, scaleH)
ResKit.sp(16)        // font size — clamped by maxFontScale
ResKit.sw(0.5)       // 50% of screen width
ResKit.sh(0.1)       // 10% of screen height
ResKit.dp(8)         // raw logical pixels

// Extension style (identical result)
200.w    100.h    12.r    16.sp    0.5.sw    0.1.sh    8.dp

// EdgeInsets helpers
ResKit.all(16)
ResKit.symmetric(vertical: 8, horizontal: 16)
ResKit.only(left: 12, top: 8, right: 12, bottom: 0)
ResKit.circular(8)          // → BorderRadius.circular(scaled)
ResKit.directional(start: 16, end: 8)  // RTL-aware
```

### Per-breakpoint Figma canvases

The active canvas switches automatically when the screen width crosses a breakpoint.
Every `.w` / `.h` / `.sp` always scales from the right frame.

```dart
// 13 built-in presets:
ResKitDesignSize.iphoneSE        // 375 × 667
ResKitDesignSize.iphone14        // 390 × 844  ← default
ResKitDesignSize.iphone14ProMax  // 430 × 932
ResKitDesignSize.androidCommon   // 360 × 800
ResKitDesignSize.androidLarge    // 412 × 915
ResKitDesignSize.ipadMini        // 768 × 1024
ResKitDesignSize.ipadPro11       // 834 × 1194
ResKitDesignSize.ipadPro12       // 1024 × 1366
ResKitDesignSize.macbookAir      // 1440 × 900
ResKitDesignSize.webBrowser      // 1280 × 800
ResKitDesignSize.fullHD          // 1920 × 1080
ResKitDesignSize.qhd             // 2560 × 1440
```

---

## 3. ResKit.builder()

```dart
// Only mobile is required. Everything else falls back toward mobile.
ResKit.builder(
  mobile:       MobileScreen(),
  mobileLarge:  PhabletScreen(),       // optional fine-tune
  tabletSmall:  SmallTabletScreen(),   // optional
  tablet:       TabletScreen(),
  tabletLarge:  LargeTabletScreen(),   // optional
  desktop:      DesktopScreen(),
  desktopLarge: UltraWideScreen(),     // ≥ 1440 dp
  desktopXL:    FourKScreen(),         // ≥ 1920 dp
  web:          WebScreen(),           // platform override (kIsWeb)
  onLayout: (ResKitLayoutInfo info) {
    print(info.layoutType);    // ResKitLayoutType.tablet
    print(info.activeDesign);  // ResKitDesignSize(768×1024)
    print(info.screenWidth);   // 800.0
  },
)

// Builder callbacks also accepted:
ResKit.builder(
  mobileBuilder:  (ctx) => MobileScreen(),
  desktopBuilder: (ctx) => DesktopScreen(),
)

// Context shortcut:
context.responsiveBuilder(mobile: A(), tablet: B(), desktop: C())
```

---

## 4. Typography

```dart
Text('Hero',    style: ResKitTypography.display())
Text('H1',      style: ResKitTypography.h1())
Text('H2',      style: ResKitTypography.h2())
Text('Title',   style: ResKitTypography.titleLarge())
Text('Body',    style: ResKitTypography.body())
Text('Caption', style: ResKitTypography.caption())
Text('LABEL',   style: ResKitTypography.overline())

// Custom Figma size
Text('Custom', style: ResKitTypography.custom(22, fontWeight: FontWeight.w700))

// Fluid: interpolates min↔max as screen width grows
Text('Fluid', style: ResKitTypography.fluid(minSp: 14, maxSp: 28))

// Or use the FluidText widget directly
FluidText('Responsive Heading', minSp: 18, maxSp: 40,
    style: TextStyle(fontWeight: FontWeight.w700))

// Adaptive per breakpoint
Text('Adaptive', style: ResKitTypography.adaptive(
  mobile:  ResKitTypography.body(),
  tablet:  ResKitTypography.h6(),
  desktop: ResKitTypography.h4(),
))

// Full Flutter TextTheme (use in MaterialApp)
theme: ThemeData(textTheme: ResKitTextTheme.build())
// Or merge into existing:
theme: ThemeData(textTheme: ResKitTextTheme.merge(myExistingTheme))
```

---

## 5. Spacing

```dart
// Tokens — automatically larger on bigger screens
ResKitSpacing.xs2   // 2 dp base
ResKitSpacing.xs    // 4 dp
ResKitSpacing.sm    // 8 dp
ResKitSpacing.md    // 16 dp  ← most common
ResKitSpacing.lg    // 24 dp
ResKitSpacing.xl    // 32 dp
ResKitSpacing.xxl   // 48 dp
ResKitSpacing.xxxl  // 64 dp

// Pre-built EdgeInsets
ResKitInsets.pagePadding      // responsive horizontal + vertical
ResKitInsets.cardPadding      // standard card content
ResKitInsets.buttonPadding    // horizontal button
ResKitInsets.inputPadding     // text field
ResKitInsets.dialogPadding    // modal dialog
ResKitInsets.bottomSheetPadding

// SizedBox gap helpers
ResKitInsets.gapSm   // vertical gap
ResKitInsets.gapMd
ResKitInsets.gapLg
ResKitInsets.hGapMd  // horizontal gap
```

---

## 6. Grid

```dart
// 12-column responsive grid
ResKitGrid(
  children: [
    ResKitGridItem(mobile: 12, tablet: 6, desktop: 4,  child: Card()),
    ResKitGridItem(mobile: 12, tablet: 6, desktop: 4,  child: Card()),
    ResKitGridItem(mobile: 12, tablet: 6, desktop: 4,  child: Card()),
    // Editorial: article + sidebar
    ResKitGridItem(mobile: 12, desktop: 8, child: Article()),
    ResKitGridItem(mobile: 12, desktop: 4, child: Sidebar()),
  ],
)

// Auto-flow: as many columns as fit
ResKitFlexGrid(
  minItemWidth: 160,       // Figma px — scales to screen
  childAspectRatio: 1.5,
  children: products.map((p) => ProductCard(p)).toList(),
)
```

---

## 7. Adaptive Navigation

```dart
ResKitNavScaffold(
  destinations: [
    ResKitNavDestination(icon: Icon(Icons.home), label: 'Home'),
    ResKitNavDestination(icon: Icon(Icons.search), label: 'Search'),
    ResKitNavDestination(
      icon: Icon(Icons.notifications_outlined),
      label: 'Alerts',
      badge: Text('3'),    // badge support
    ),
  ],
  selectedIndex: _index,
  onDestinationSelected: (i) => setState(() => _index = i),
  body: _pages[_index],
  // Automatically shows:
  // Mobile      → BottomNavigationBar
  // Tablet      → NavigationRail (collapsed)
  // TabletLarge → NavigationRail (extended)
  // Desktop     → NavigationDrawer sidebar
)
```

---

## 8. Theme Integration

```dart
// Fully scaled Material 3 ThemeData
MaterialApp(
  theme: ResKitThemeData.build(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    fontFamily: 'Inter',
  ),
)

// Access custom tokens anywhere
final ext = ResKitThemeExtension.fromResKit();
ext.cardRadius            // ResKit.radius(12)
ext.pageHorizontalPadding // adaptive: 16/24/40
ext.sectionSpacing        // ResKitSpacing.xl

// Register as ThemeExtension for Theme.of(context) access
ThemeData(extensions: [ResKitThemeExtension.fromResKit()])
```

---

## 9. Accessibility

```dart
ResKitAccessibility.reducedMotion   // OS "Reduce Motion" setting
ResKitAccessibility.highContrast    // High Contrast mode
ResKitAccessibility.boldText        // Bold Text accessibility
ResKitAccessibility.minTapTarget    // 48 dp (WCAG compliant)

// Reduce animations automatically
AnimatedContainer(
  duration: ResKitAccessibility.duration(Duration(milliseconds: 300)),
  // → 300ms normally, Duration.zero when reducedMotion=true
)

// Minimum tap target enforcement
ResKitAccessibility.ensureTapTarget(child: SmallIcon())
```

---

## 10. RTL Support

```dart
// RTL-aware EdgeInsetsDirectional
ResKit.directional(start: 16, end: 8, top: 12, bottom: 12)

// RTL-aware padding widget
ResKitRTLPadding(
  start: 24, end: 8, top: 12, bottom: 12,
  child: Text('Flips in Arabic/Hebrew'),
)

// Context guards
context.isRTL           // true in Arabic, Hebrew, etc.
context.isLTR
context.textDirection   // TextDirection.rtl / .ltr
```

---

## 11. Platform Detection

```dart
ResKit.isAndroid / isIOS / isWeb / isMacOS / isWindows / isLinux / isFuchsia
ResKit.isNativeMobile / isNativeDesktop
ResKit.platform    // ResKitOS enum

// Per-platform value
ResKit.perPlatform(android: 4.0, ios: 0.0, web: 2.0, fallback: 1.0)

// Platform-based widget
AdaptiveBuilder(
  android:      MaterialWidget(),
  ios:          CupertinoWidget(),
  web:          WebWidget(),
  nativeDesktop: DesktopWidget(),
  fallback:     DefaultWidget(),
)
```

---

## 12. Images

```dart
// Local assets
ResKitImage(
  mobile:  'assets/hero_mobile.png',
  tablet:  'assets/hero_tablet.png',
  desktop: 'assets/hero_desktop.png',
  fit: BoxFit.cover,
  width: double.infinity,
)

// Network images
ResKitNetworkImage(
  mobile:  'https://cdn.example.com/hero_sm.jpg',
  desktop: 'https://cdn.example.com/hero_xl.jpg',
  height: 300.h,
)

// Decoration image
BoxDecoration(
  image: ResKitDecorationImage.resolve(
    mobile:  'assets/bg_mobile.png',
    desktop: 'assets/bg_desktop.png',
  ),
)
```

---

## 13. BuildContext Extensions

```dart
context.screenWidth / screenHeight / devicePixelRatio
context.statusBarHeight / bottomBarHeight / keyboardHeight / isKeyboardOpen
context.safeAreaPadding / brightness / isDarkMode
context.w(200) / h(100) / r(12) / sp(16) / sw(0.5) / sh(0.1) / dp(8)
context.fluidSp(minSp: 14, maxSp: 28)
context.scaleW / scaleH / scale / textScale
context.figmaWidth / figmaHeight / activeDesign
context.isPortrait / isLandscape
context.isRTL / isLTR / textDirection
context.reducedMotion / highContrast / boldText / invertColors
context.isMobileSmall / isMobile / isMobileLarge
context.isTabletSmall / isTablet / isTabletLarge
context.isDesktop / isDesktopLarge / isDesktopXL
context.deviceType                  // ResKitDeviceType enum
context.isAndroid / isIOS / isWeb / isMacOS / isWindows / isLinux / isFuchsia
context.isNativeMobile / isNativeDesktop
context.platform                    // ResKitOS enum
context.adaptive(mobile: 1, tablet: 2, desktop: 4)
context.perPlatform(android: …, ios: …, fallback: …)
context.responsiveBuilder(mobile: …, tablet: …, desktop: …, web: …)
```

---

## 14. Testing

```dart
// Unit tests — no widget tree needed
void main() {
  setUp(() => ResKitTestHelper.initMobile());
  // or: ResKitTestHelper.initTablet() / initDesktop()
  // or: ResKitTestHelper.init(size: ResKitTestSizes.ipadPro11)

  test('width scales correctly', () {
    expect(ResKit.width(390), closeTo(390, 0.01));
  });
}

// Widget tests
testWidgets('shows correct layout', (tester) async {
  await ResKitTestHelper.pumpWidget(
    tester,
    widget: MyScreen(),
    size: ResKitTestSizes.ipadMini,
  );
  expect(find.byType(NavigationRail), findsOneWidget);
});

// Test at multiple sizes
testWidgets('nav adapts across sizes', (tester) async {
  await ResKitTestHelper.pumpAtSizes(
    tester,
    widget: MyApp(),
    sizes: [
      ResKitTestSizes.iphone14,
      ResKitTestSizes.ipadMini,
      ResKitTestSizes.macbookAir,
    ],
    check: (size) {
      if (size.width <= 480) {
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      } else {
        expect(find.byType(NavigationRail), findsOneWidget);
      }
    },
  );
});

// Preset sizes
ResKitTestSizes.iphone14      // 390 × 844
ResKitTestSizes.ipadMini      // 768 × 1024
ResKitTestSizes.macbookAir    // 1440 × 900
ResKitTestSizes.fullHD        // 1920 × 1080
ResKitTestSizes.webBrowser    // 1280 × 800
ResKitTestSizes.androidPixel7 // 412 × 915
// … 13 presets total
```

---

## 15. Debug

```dart
ResKit.debugPrint();
// Prints: design config, active canvas, screen size, physical size,
//         scale factors, all breakpoints, safe area, accessibility flags,
//         platform, and sample scaled values — all in one call.

// Programmatic access
ResKitUtils.diagnosticMap() // → Map<String, dynamic>
```

---

## Migration from flutter_screenutil

| flutter_screenutil | flutter_responsive_kit |
|---|---|
| `ScreenUtil.init()` inside build | `ResponsiveKit(config:…)` at root, once |
| `200.w` `100.h` `12.r` `16.sp` | ✅ identical — no migration needed |
| `ScreenUtil().screenWidth` | `ResKit.screenWidth` |
| Single canvas only | Multi-canvas: `ResKitConfig(designs: ResKitDesignConfig(…))` |
| No typography system | `ResKitTypography.h1()` / `ResKitTextTheme.build()` |
| No navigation | `ResKitNavScaffold` |
| No grid | `ResKitGrid` / `ResKitFlexGrid` |
| No theme builder | `ResKitThemeData.build()` |
| No accessibility | `ResKitAccessibility.*` |
| No RTL helpers | `ResKit.directional()` / `ResKitRTLPadding` |
| No test helpers | `ResKitTestHelper.*` |

---

## License

MIT © 2025 Mysterious Coder
