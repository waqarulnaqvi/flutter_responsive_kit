/// flutter_responsive_plus v2.0 — The Complete Flutter Responsive Toolkit
///
/// Single import gives you everything:
///
/// CORE
///   [ResponsiveKit]         — root initialiser widget
///   [ResKit]                — global static namespace
///   [ResKitConfig]          — full configuration
///   [ResKitDesignConfig]    — per-breakpoint Figma canvases
///   [ResKitDesignSize]      — canvas size + 12 named presets
///   [ResKitBreakpoints]     — breakpoint thresholds + presets
///
/// PLATFORM
///   [ResKitPlatform]        — platform detection
///   [ResKitOS]              — OS enum
///
/// EXTENSIONS
///   num / int / double      — .w .h .r .sp .sw .sh .dp .pt
///   BuildContext            — context.w() context.isTablet context.responsiveBuilder()
///
/// TYPOGRAPHY
///   [ResKitTypography]      — responsive text styles (h1–h6, body, caption…)
///   [ResKitTextTheme]       — full Flutter TextTheme integration
///
/// SPACING
///   [ResKitSpacing]         — adaptive spacing tokens (xs–xxl)
///   [ResKitInsets]          — adaptive EdgeInsets presets
///
/// GRID
///   [ResKitGrid]            — 12-column responsive grid widget
///   [ResKitGridItem]        — grid item with span control
///   [ResKitFlexGrid]        — auto-flow flex-wrap grid
///
/// NAVIGATION
///   [ResKitNavScaffold]     — auto: BottomNav → Rail → Drawer
///   [ResKitNavDestination]  — destination model
///
/// IMAGES
///   [ResKitImage]           — breakpoint-aware asset switcher
///   [ResKitNetworkImage]    — breakpoint-aware network image
///
/// THEME
///   [ResKitThemeData]       — fully scaled ThemeData builder
///   [ResKitTheme]           — InheritedWidget for theme access
///
/// ACCESSIBILITY
///   [ResKitAccessibility]   — reducedMotion, highContrast, boldText…
///
/// WIDGETS
///   [ResponsiveBuilder]     — LayoutBuilder device-type switcher
///   [TriStateResponsiveBuilder]
///   [AdaptiveBuilder]       — platform-based widget switcher
///   [WebContentWrapper]     — max-width web layout
///   [ResponsiveVisibility]  — conditional widget visibility
///   [ResKitMediaQuery]      — scoped MediaQuery override
///   [FluidText]             — viewport-interpolated text size
///   [ResKitRTLPadding]      — RTL-aware padding/margin
///
/// TESTING
///   [ResKitTestHelper]      — pump widget at any screen size
///   [ResKitTestSizes]       — common test size presets
///
/// UTILS
///   [ResKitUtils]           — grid math, aspect-fit, safe-area, debug
library flutter_responsive_plus;

// Core
export 'src/core/res_kit.dart';
export 'src/core/res_kit_config.dart';
export 'src/core/res_kit_breakpoints.dart';
export 'src/core/res_kit_design_config.dart';
export 'src/core/responsive_kit_init.dart';

// Platform
export 'src/platform/res_kit_platform.dart';
export 'src/platform/res_kit_os.dart';

// Extensions
export 'src/extensions/num_extensions.dart';
export 'src/extensions/context_extensions.dart';

// Typography
export 'src/typography/res_kit_typography.dart';
export 'src/typography/res_kit_text_theme.dart';

// Spacing
export 'src/spacing/res_kit_spacing.dart';
export 'src/spacing/res_kit_insets.dart';

// Grid
export 'src/grid/res_kit_grid.dart';
export 'src/grid/res_kit_flex_grid.dart';

// Navigation
export 'src/navigation/res_kit_nav_scaffold.dart';

// Images
export 'src/widgets/res_kit_image.dart';

// Theme
export 'src/theme/res_kit_theme.dart';

// Accessibility
export 'src/utils/res_kit_accessibility.dart';

// Widgets
export 'src/widgets/responsive_builder.dart';
export 'src/widgets/adaptive_builder.dart';
export 'src/widgets/res_kit_media_query.dart';
export 'src/widgets/fluid_text.dart';
export 'src/widgets/rtl_padding.dart';

// Testing
export 'src/testing/res_kit_test_helper.dart';

// Utils
export 'src/utils/res_kit_utils.dart';
