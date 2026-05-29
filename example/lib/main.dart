import 'package:flutter/material.dart';
import 'package:flutter_responsive_kit/flutter_responsive_kit.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveKit(
      config: ResKitConfig(
        // ── Per-breakpoint Figma canvases ─────────────────────────────
        designs: ResKitDesignConfig(
          mobile:  ResKitDesignSize.iphone14,       // 390 × 844
          tablet:  ResKitDesignSize.ipadMini,        // 768 × 1024
          desktop: ResKitDesignSize.macbookAir,      // 1440 × 900
          web:     ResKitDesignSize.webBrowser,      // 1280 × 800
        ),
        maxFontScale: 1.3,
        breakpoints:  ResKitBreakpoints.material3(),
      ),
      child: Builder(builder: (ctx) {
        // ── Fully scaled ThemeData ────────────────────────────────────
        final theme = ResKitThemeData.build(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: MediaQuery.platformBrightnessOf(ctx),
          ),
          fontFamily: null,
        );
        return MaterialApp(
          title: 'flutter_responsive_kit v2.0',
          debugShowCheckedModeBanner: false,
          theme: theme,
          // ── ResKit.builder at root level ──────────────────────────
          home: ResKit.builder(
            // FIX: Use mobileBuilder, tabletBuilder, etc. when passing a closure
            mobileBuilder:  (ctx) => const MobileShell(),
            tabletBuilder:  (ctx) => const TabletShell(),
            desktopBuilder: (ctx) => const DesktopShell(),
            webBuilder:     (ctx) => const WebShell(),
            onLayout: (info) {
              // ignore: avoid_print
              print('[ResKit] Layout: ${info.layoutType} | '
                  'Canvas: ${info.activeDesign} | '
                  '${info.screenWidth.toStringAsFixed(0)}×${info.screenHeight.toStringAsFixed(0)}');
            },
          ),
        );
      }),
    );
  }
}

// ─── Navigation destinations (shared) ─────────────────────────────────────
final _destinations = [
  ResKitNavDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
  ResKitNavDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Grid'),
  ResKitNavDestination(icon: Icon(Icons.text_fields_outlined), selectedIcon: Icon(Icons.text_fields), label: 'Typography'),
  ResKitNavDestination(icon: Icon(Icons.palette_outlined), selectedIcon: Icon(Icons.palette), label: 'Theme'),
  ResKitNavDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: 'Debug'),
];

// ─── Mobile shell ─────────────────────────────────────────────────────────
class MobileShell extends StatefulWidget {
  const MobileShell({super.key});
  @override State<MobileShell> createState() => _MobileShellState();
}
class _MobileShellState extends State<MobileShell> {
  int _idx = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ResKit.debugPrint());
  }
  @override
  Widget build(BuildContext context) {
    return ResKitNavScaffold(
      destinations: _destinations,
      selectedIndex: _idx,
      onDestinationSelected: (i) => setState(() => _idx = i),
      appBar: AppBar(
        title: Text('📱 ${_destinations[_idx].label}',
            style: ResKitTypography.titleLarge()),
        elevation: 0,
      ),
      body: _pages[_idx],
    );
  }
}

// ─── Tablet shell ─────────────────────────────────────────────────────────
class TabletShell extends StatefulWidget {
  const TabletShell({super.key});
  @override State<TabletShell> createState() => _TabletShellState();
}
class _TabletShellState extends State<TabletShell> {
  int _idx = 0;
  @override
  Widget build(BuildContext context) => ResKitNavScaffold(
    destinations: _destinations,
    selectedIndex: _idx,
    onDestinationSelected: (i) => setState(() => _idx = i),
    appBar: AppBar(title: Text('📟 ${_destinations[_idx].label}',
        style: ResKitTypography.titleLarge())),
    body: _pages[_idx],
  );
}

// ─── Desktop shell ────────────────────────────────────────────────────────
class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});
  @override State<DesktopShell> createState() => _DesktopShellState();
}
class _DesktopShellState extends State<DesktopShell> {
  int _idx = 0;
  @override
  Widget build(BuildContext context) => ResKitNavScaffold(
    destinations: _destinations,
    selectedIndex: _idx,
    onDestinationSelected: (i) => setState(() => _idx = i),
    drawerHeader: Padding(
      padding: ResKitInsets.cardPadding,
      child: Text('🖥️ Desktop', style: ResKitTypography.h5()),
    ),
    body: WebContentWrapper(child: _pages[_idx]),
  );
}

// ─── Web shell ────────────────────────────────────────────────────────────
class WebShell extends StatefulWidget {
  const WebShell({super.key});
  @override State<WebShell> createState() => _WebShellState();
}
class _WebShellState extends State<WebShell> {
  int _idx = 0;
  @override
  Widget build(BuildContext context) => ResKitNavScaffold(
    destinations: _destinations,
    selectedIndex: _idx,
    onDestinationSelected: (i) => setState(() => _idx = i),
    drawerHeader: Padding(
      padding: ResKitInsets.cardPadding,
      child: Text('🌐 Web', style: ResKitTypography.h5()),
    ),
    body: WebContentWrapper(maxWidth: 1280, child: _pages[_idx]),
  );
}

// ─── Pages ────────────────────────────────────────────────────────────────
final _pages = [
  const HomePage(),
  const GridPage(),
  const TypographyPage(),
  const ThemePage(),
  const DebugPage(),
];

// ═══════════════════════════════════════════════════════════════════════════
// HOME PAGE
// ═══════════════════════════════════════════════════════════════════════════
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResKitInsets.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Active canvas banner
        _CanvasBanner(),
        SizedBox(height: ResKitSpacing.lg),

        // Sizing API demo
        _Section('Sizing API — ResKit.* + extensions'),
        _InfoCard(children: [
          _Row('ResKit.width(200) / 200.w',  ResKit.width(200).toStringAsFixed(2)),
          _Row('ResKit.height(100) / 100.h', ResKit.height(100).toStringAsFixed(2)),
          _Row('ResKit.radius(12) / 12.r',   ResKit.radius(12).toStringAsFixed(2)),
          _Row('ResKit.sp(16) / 16.sp',      ResKit.sp(16).toStringAsFixed(2)),
          _Row('ResKit.sw(0.5)',              ResKit.sw(0.5).toStringAsFixed(2)),
          _Row('ResKit.sh(0.1)',              ResKit.sh(0.1).toStringAsFixed(2)),
          _Row('ResKit.fluidSp(12,28)',       ResKit.fluidSp(minSp:12, maxSp:28).toStringAsFixed(2)),
          _Row('0.5.sw / 0.1.sh',            '${0.5.sw.toStringAsFixed(1)} / ${0.1.sh.toStringAsFixed(1)}'),
        ]),
        SizedBox(height: ResKitSpacing.lg),

        // Spacing tokens
        _Section('Spacing Tokens — ResKitSpacing'),
        _InfoCard(children: [
          _Row('ResKitSpacing.xs2', ResKitSpacing.xs2.toStringAsFixed(2)),
          _Row('ResKitSpacing.xs',  ResKitSpacing.xs.toStringAsFixed(2)),
          _Row('ResKitSpacing.sm',  ResKitSpacing.sm.toStringAsFixed(2)),
          _Row('ResKitSpacing.md',  ResKitSpacing.md.toStringAsFixed(2)),
          _Row('ResKitSpacing.lg',  ResKitSpacing.lg.toStringAsFixed(2)),
          _Row('ResKitSpacing.xl',  ResKitSpacing.xl.toStringAsFixed(2)),
          _Row('ResKitSpacing.xxl', ResKitSpacing.xxl.toStringAsFixed(2)),
          _Row('ResKitSpacing.xxxl',ResKitSpacing.xxxl.toStringAsFixed(2)),
        ]),
        SizedBox(height: ResKitSpacing.lg),

        // Platform + accessibility
        _Section('Platform & Accessibility'),
        _InfoCard(children: [
          _Row('platform',        ResKit.platform.name),
          _Row('isAndroid',       '${ResKit.isAndroid}'),
          _Row('isIOS',           '${ResKit.isIOS}'),
          _Row('isWeb',           '${ResKit.isWeb}'),
          _Row('isMacOS',         '${ResKit.isMacOS}'),
          _Row('isWindows',       '${ResKit.isWindows}'),
          _Row('isLinux',         '${ResKit.isLinux}'),
          const Divider(),
          _Row('reducedMotion',   '${ResKit.reducedMotion}'),
          _Row('highContrast',    '${ResKit.highContrast}'),
          _Row('boldText',        '${ResKit.boldText}'),
          _Row('systemTextScale', ResKit.systemTextScaleFactor.toStringAsFixed(2)),
        ]),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GRID PAGE
// ═══════════════════════════════════════════════════════════════════════════
class GridPage extends StatelessWidget {
  const GridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResKitInsets.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Section('ResKitGrid — 12-column responsive grid'),
        Text('Spans: mobile=12, tablet=6, desktop=4',
            style: ResKitTypography.caption(color: Colors.grey)),
        SizedBox(height: ResKitSpacing.sm),
        ResKitGrid(
          children: List.generate(6, (i) => ResKitGridItem(
            mobile: 12, tablet: 6, desktop: 4,
            child: _GridCard(i + 1),
          )),
        ),
        SizedBox(height: ResKitSpacing.xl),

        _Section('ResKitFlexGrid — auto-flow (minItemWidth: 140)'),
        ResKitFlexGrid(
          minItemWidth: 140,
          childAspectRatio: 1.5,
          children: List.generate(8, (i) => _GridCard(i + 1)),
        ),
        SizedBox(height: ResKitSpacing.xl),

        _Section('ResKitGrid — editorial layout (mobile full, desktop 8+4)'),
        ResKitGrid(
          gutter: ResKitSpacing.lg,
          children: [
            ResKitGridItem(mobile: 12, desktop: 8, child: _ArticleCard()),
            ResKitGridItem(mobile: 12, desktop: 4, child: _SidebarCard()),
          ],
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TYPOGRAPHY PAGE
// ═══════════════════════════════════════════════════════════════════════════
class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResKitInsets.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Section('ResKitTypography'),
        Text('display',     style: ResKitTypography.display()),
        ResKitInsets.gapSm,
        Text('displaySmall',style: ResKitTypography.displaySmall()),
        ResKitInsets.gapSm,
        Text('h1 Heading',  style: ResKitTypography.h1()),
        Text('h2 Heading',  style: ResKitTypography.h2()),
        Text('h3 Heading',  style: ResKitTypography.h3()),
        Text('h4 Heading',  style: ResKitTypography.h4()),
        Text('h5 Heading',  style: ResKitTypography.h5()),
        Text('h6 Heading',  style: ResKitTypography.h6()),
        ResKitInsets.gapMd,
        Text('titleLarge',  style: ResKitTypography.titleLarge()),
        Text('titleMedium', style: ResKitTypography.titleMedium()),
        Text('titleSmall',  style: ResKitTypography.titleSmall()),
        ResKitInsets.gapMd,
        Text('bodyLarge — The quick brown fox jumps over the lazy dog.',
            style: ResKitTypography.bodyLarge()),
        Text('body — The quick brown fox jumps over the lazy dog.',
            style: ResKitTypography.body()),
        Text('bodySmall — The quick brown fox jumps over the lazy dog.',
            style: ResKitTypography.bodySmall()),
        ResKitInsets.gapMd,
        Text('labelLarge', style: ResKitTypography.labelLarge()),
        Text('label',      style: ResKitTypography.label()),
        Text('labelSmall', style: ResKitTypography.labelSmall()),
        Text('caption',    style: ResKitTypography.caption()),
        Text('OVERLINE',   style: ResKitTypography.overline()),
        Text('BUTTON',     style: ResKitTypography.button()),
        ResKitInsets.gapLg,

        _Section('FluidText — interpolates min↔max with screen width'),
        FluidText('Fluid Heading', minSp: 18, maxSp: 40,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        FluidText('Fluid Body text scales smoothly across all screens.',
            minSp: 13, maxSp: 18),
        ResKitInsets.gapLg,

        _Section('ResKitTypography.adaptive'),
        Text('Adaptive size per breakpoint',
          style: ResKitTypography.adaptive(
            mobile:  ResKitTypography.body(),
            tablet:  ResKitTypography.h6(),
            desktop: ResKitTypography.h4(),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// THEME PAGE
// ═══════════════════════════════════════════════════════════════════════════
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResKitInsets.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Section('ResKitInsets presets'),
        _InfoCard(children: [
          _Row('pagePadding.horizontal', ResKitInsets.pagePadding.horizontal.toStringAsFixed(1)),
          _Row('cardPadding',            ResKitInsets.cardPadding.left.toStringAsFixed(1)),
          _Row('buttonPadding.h',        ResKitInsets.buttonPadding.horizontal.toStringAsFixed(1)),
          _Row('inputPadding.v',         ResKitInsets.inputPadding.vertical.toStringAsFixed(1)),
          _Row('dialogPadding',          ResKitInsets.dialogPadding.left.toStringAsFixed(1)),
        ]),
        SizedBox(height: ResKitSpacing.lg),

        _Section('RTL-aware padding (ResKitRTLPadding)'),
        Container(
          color: Colors.amber.withAlpha(30),
          child: ResKitRTLPadding(
            start: 24, end: 8, top: 12, bottom: 12,
            child: Text('start=24, end=8 (flips in RTL)',
                style: ResKitTypography.body()),
          ),
        ),
        SizedBox(height: ResKitSpacing.lg),

        _Section('Accessibility (ResKitAccessibility)'),
        _InfoCard(children: [
          _Row('reducedMotion',  '${ResKitAccessibility.reducedMotion}'),
          _Row('highContrast',   '${ResKitAccessibility.highContrast}'),
          _Row('boldText',       '${ResKitAccessibility.boldText}'),
          _Row('invertColors',   '${ResKitAccessibility.invertColors}'),
          _Row('minTapTarget',   '${ResKitAccessibility.minTapTarget.toStringAsFixed(1)} dp'),
          _Row('textScaleFactor','${ResKitAccessibility.textScaleFactor.toStringAsFixed(2)}'),
        ]),
        SizedBox(height: ResKitSpacing.lg),

        _Section('Adaptive animation duration'),
        Builder(builder: (_) {
          final dur = ResKitAccessibility.duration(const Duration(milliseconds: 300));
          return _InfoCard(children: [
            _Row('duration(300ms)', '${dur.inMilliseconds} ms (0 if reduced)'),
          ]);
        }),
        SizedBox(height: ResKitSpacing.lg),

        _Section('ResKitThemeExtension tokens'),
        Builder(builder: (ctx) {
          final ext = ResKitThemeExtension.fromResKit();
          return _InfoCard(children: [
            _Row('cardRadius',            ext.cardRadius!.toStringAsFixed(2)),
            _Row('buttonRadius',          ext.buttonRadius!.toStringAsFixed(2)),
            _Row('pageHorizontalPadding', ext.pageHorizontalPadding!.toStringAsFixed(2)),
            _Row('sectionSpacing',        ext.sectionSpacing!.toStringAsFixed(2)),
          ]);
        }),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DEBUG PAGE
// ═══════════════════════════════════════════════════════════════════════════
class DebugPage extends StatelessWidget {
  const DebugPage({super.key});
  @override
  Widget build(BuildContext context) {
    final map = ResKitUtils.diagnosticMap();
    return SingleChildScrollView(
      padding: ResKitInsets.pagePadding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _Section('ResKit.debugPrint() — see console'),
        FilledButton.icon(
          onPressed: ResKit.debugPrint,
          icon: const Icon(Icons.bug_report),
          label: const Text('Print Diagnostic'),
        ),
        SizedBox(height: ResKitSpacing.lg),
        _Section('ResKitUtils.diagnosticMap()'),
        _InfoCard(children: map.entries
            .map((e) => _Row(e.key, '${e.value}'))
            .toList()),
        SizedBox(height: ResKitSpacing.lg),
        _Section('context.* extensions'),
        _InfoCard(children: [
          _Row('context.screenWidth',  context.screenWidth.toStringAsFixed(1)),
          _Row('context.figmaWidth',   context.figmaWidth.toStringAsFixed(0)),
          _Row('context.figmaHeight',  context.figmaHeight.toStringAsFixed(0)),
          _Row('context.activeDesign', '${context.activeDesign}'),
          _Row('context.isRTL',        '${context.isRTL}'),
          _Row('context.isDarkMode',   '${context.isDarkMode}'),
          _Row('context.isMobile',     '${context.isMobile}'),
          _Row('context.isTablet',     '${context.isTablet}'),
          _Row('context.isDesktop',    '${context.isDesktop}'),
          _Row('context.reducedMotion','${context.reducedMotion}'),
        ]),
      ]),
    );
  }
}

// ─── Shared UI helpers ────────────────────────────────────────────────────
class _CanvasBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final design = ResKit.activeDesign;
    final c = ResKit.isMobile ? Colors.blue : ResKit.isTablet ? Colors.green : Colors.purple;
    return Container(
      width: double.infinity,
      padding: ResKitInsets.cardPadding,
      decoration: BoxDecoration(
        color: c.withAlpha(18),
        borderRadius: ResKit.circular(10),
        border: Border.all(color: c.withAlpha(70)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Active Figma Canvas', style: ResKitTypography.overline(color: c)),
        Text('${design.width.toStringAsFixed(0)} × ${design.height.toStringAsFixed(0)} dp',
            style: ResKitTypography.h3(color: c)),
        Text('scaleW: ${ResKit.scaleW.toStringAsFixed(3)}  '
             'scaleH: ${ResKit.scaleH.toStringAsFixed(3)}  '
             'deviceType: ${ResKit.deviceType.name}',
            style: ResKitTypography.caption(color: c.withAlpha(160))),
      ]),
    );
  }
}

class _GridCard extends StatelessWidget {
  const _GridCard(this.n);
  final int n;
  @override
  Widget build(BuildContext context) => Container(
    padding: ResKitInsets.cardPaddingSmall,
    decoration: BoxDecoration(
      color: Colors.primaries[n % Colors.primaries.length].withAlpha(28),
      borderRadius: ResKit.circular(8),
      border: Border.all(
          color: Colors.primaries[n % Colors.primaries.length].withAlpha(80)),
    ),
    alignment: Alignment.center,
    child: Text('Card $n', style: ResKitTypography.label()),
  );
}

class _ArticleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: ResKitInsets.cardPadding,
    decoration: BoxDecoration(
      color: Colors.indigo.withAlpha(18),
      borderRadius: ResKit.circular(10),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Article (8 cols on desktop)', style: ResKitTypography.h5()),
      SizedBox(height: ResKitSpacing.sm),
      Text('This is the main article content area.', style: ResKitTypography.body()),
    ]),
  );
}

class _SidebarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: ResKitInsets.cardPadding,
    decoration: BoxDecoration(
      color: Colors.orange.withAlpha(18),
      borderRadius: ResKit.circular(10),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Sidebar (4 cols)', style: ResKitTypography.h6()),
      SizedBox(height: ResKitSpacing.sm),
      Text('Related links, ads, or widgets.', style: ResKitTypography.bodySmall()),
    ]),
  );
}

class _Section extends StatelessWidget {
  const _Section(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: ResKitSpacing.sm, top: ResKitSpacing.xs),
    child: Text(text, style: ResKitTypography.h6(
        color: Theme.of(context).colorScheme.primary)),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ResKitInsets.cardPadding,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      borderRadius: ResKit.circular(8),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );
}

class _Row extends StatelessWidget {
  const _Row(this.k, this.v);
  final String k, v;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 2.h),
    child: Row(children: [
      Expanded(child: Text(k, style: ResKitTypography.caption(
          color: Theme.of(context).colorScheme.onSurfaceVariant)
          .copyWith(fontFamily: 'monospace'))),
      Text(v, style: ResKitTypography.caption()
          .copyWith(fontWeight: FontWeight.w700, fontFamily: 'monospace')),
    ]),
  );
}
