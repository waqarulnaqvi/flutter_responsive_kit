## 1.0.1

- Fixed `pubspec.yaml` description length (now within 60–180 characters).
- Removed unreachable `homepage` URL to pass pub.dev validation.

## 1.0.0

### ✨ Core
- `ResKit` global namespace — sizing, screen info, breakpoints, platform, accessibility.
- `ResponsiveKit` root widget with `WidgetsBindingObserver` for automatic metric updates.
- `ResKitConfig` — single-canvas and multi-canvas (per-breakpoint Figma) mode.
- `ResKitDesignConfig` — separate Figma canvases for mobile / tablet / desktop / web and fine-grained slots.
- `ResKitDesignSize` — 13 named presets (`iphone14`, `ipadMini`, `macbookAir`, `fullHD`, `qhd` …).
- `ResKitBreakpoints` — 9 breakpoints + Bootstrap / Material 3 / Tailwind presets.
- `ResKit.builder()` — 9-slot layout picker; accepts static widgets or builder callbacks + `onLayout`.
- `ResKit.fluidSp()` — fluid/viewport-interpolated font sizes (CSS `clamp()` equivalent).
- `ResKit.directional()` — RTL-aware `EdgeInsetsDirectional`.
- `ResKit.reducedMotion` / `.highContrast` / `.boldText` / `.invertColors` / `.accessibleNavigation`.

### ✨ Typography (`ResKitTypography`)
- Full type scale: `display` / `displaySmall` / `h1`–`h6` / `titleLarge`–`Small` /
  `bodyLarge`–`Small` / `labelLarge`–`Small` / `caption` / `overline` / `button` /
  `custom` / `fluid` / `adaptive`.
- `ResKitTextTheme.build()` — complete Flutter `TextTheme` from the active Figma canvas.
- `ResKitTextTheme.merge()` — scale any existing `TextTheme` without losing styles.

### ✨ Spacing (`ResKitSpacing` / `ResKitInsets`)
- 8 adaptive tokens: `xs2` / `xs` / `sm` / `md` / `lg` / `xl` / `xxl` / `xxxl` —
  with breakpoint multipliers (1× mobile → 1.125× tablet → 1.25× desktop → 1.5× desktopLarge).
- Pre-built `EdgeInsets` presets: `pagePadding` / `cardPadding` / `buttonPadding` /
  `inputPadding` / `dialogPadding` / `bottomSheetPadding` + gap `SizedBox` helpers.

### ✨ Grid (`ResKitGrid` / `ResKitFlexGrid`)
- `ResKitGrid` — 12-column responsive grid; per-item span declarations across `xs` / `mobile` /
  `tablet` / `desktop` / `desktopLarge`.
- `ResKitGridItem` — grid cell with span control per breakpoint.
- `ResKitFlexGrid` — auto-flow grid with `minItemWidth` (CSS `auto-fill` / `minmax` equivalent).

### ✨ Navigation (`ResKitNavScaffold`)
- Single widget that auto-switches:
  mobile → `BottomNavigationBar` | tablet → `NavigationRail` (collapsed) |
  tabletLarge → `NavigationRail` (extended) | desktop → `NavigationDrawer` sidebar.
- `ResKitNavDestination` — destination model with optional badge.

### ✨ Images
- `ResKitImage` — breakpoint-aware local asset switcher.
- `ResKitNetworkImage` — breakpoint-aware network image.
- `ResKitDecorationImage` — breakpoint-aware `DecorationImage` helper.

### ✨ Theme Integration
- `ResKitThemeData.build()` — full Material 3 `ThemeData` with all dimensions scaled:
  AppBar / Cards / Buttons (elevated / outlined / filled / text) / `InputDecoration` /
  Chips / Dialogs / BottomSheets / BottomNav / `NavigationRail` / `ListTile` /
  Icons / Dividers / Snackbar / Tooltip / FAB.
- `ResKitTheme` — `InheritedWidget` for custom theme tokens.
- `ResKitThemeExtension` — `ThemeExtension<T>` with `lerp` for card / button / input radii,
  page padding, and section spacing.

### ✨ Accessibility (`ResKitAccessibility`)
- `reducedMotion` / `highContrast` / `boldText` / `invertColors` / `accessibleNav`.
- `duration()` / `curve()` — animation helpers that respect reduced-motion setting.
- `minTapTarget` (48 dp, WCAG compliant) / `semantics()` / `ensureTapTarget()`.

### ✨ Widgets
- `ResponsiveBuilder` / `TriStateResponsiveBuilder` — `LayoutBuilder`-based device-type switcher.
- `AdaptiveBuilder` / `AdaptiveBuilderFn` — platform-based widget switcher.
- `WebContentWrapper` — max-width centred web layout.
- `ResponsiveVisibility` — conditional visibility with optional state maintenance.
- `ResKitMediaQuery` — scoped `MediaQuery` override for tests and previews.
- `FluidText` — viewport-interpolated `Text` widget.
- `ResKitRTLPadding` — RTL-aware padding widget.
- `ResKitDirectionalGap` — RTL-aware horizontal spacing gap.

### ✨ RTL Support
- `ResKit.directional()` — scaled `EdgeInsetsDirectional`.
- `ResKitRTLPadding` — `start` / `end` / `top` / `bottom` with automatic RTL flip.
- `context.isRTL` / `context.isLTR` / `context.textDirection`.

### ✨ Testing (`ResKitTestHelper` / `ResKitTestSizes`)
- `init()` / `initMobile()` / `initTablet()` / `initDesktop()` — unit-test setup without a widget tree.
- `pumpWidget()` / `pumpAtSizes()` — widget-test helpers.
- 13 preset sizes: `iphone14` / `ipadMini` / `macbookAir` / `fullHD` / `watch` …

### ✨ Extensions
- `num` / `int` / `double` — `.w` `.h` `.r` `.sp` `.dp` `.pt` `.sw` `.sh`.
- `EdgeInsets` — `.scaled`.
- `Size` — `.scaled`.
- `BuildContext` — 50+ getters and methods: `responsiveBuilder()` / `activeDesign` /
  `figmaWidth` / `figmaHeight` / `isRTL` / `isDarkMode` / `reducedMotion` /
  `highContrast` / `fluidSp()`.

### ✨ Utils (`ResKitUtils`)
- Grid math / `textStyle` / aspect-fit / `usableHeight` / `clamp` / `byOrientation` / `diagnosticMap`.
- `ResKit.debugPrint()` — full diagnostic dump: active canvas, scale factors, breakpoints,
  safe area, accessibility flags, platform, and sample values.
