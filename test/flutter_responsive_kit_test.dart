import 'package:flutter/material.dart';
import 'package:flutter_responsive_kit/flutter_responsive_kit.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
void _initAt(Size size, {ResKitConfig? config}) {
  ResKit.init(
    mediaQuery: MediaQueryData(size: size, devicePixelRatio: 3),
    config: config ??
        ResKitConfig(figmaWidth: size.width, figmaHeight: size.height),
  );
}

void _initMobile()  => _initAt(ResKitTestSizes.iphone14);
// void _initTablet()  => _initAt(ResKitTestSizes.ipadMini,
//     config: ResKitConfig(figmaWidth: 768, figmaHeight: 1024));
void _initDesktop() => _initAt(ResKitTestSizes.macbookAir,
    config: ResKitConfig(figmaWidth: 1440, figmaHeight: 900));

// ─────────────────────────────────────────────────────────────────────────────
void main() {

  // ── 1. Scale factors ────────────────────────────────────────────────────
  group('ResKit — scale factors', () {
    test('scaleW == 1.0 when screen matches Figma width', () {
      _initMobile();
      expect(ResKit.scaleW, closeTo(1.0, 1e-6));
    });

    test('scaleH == 1.0 when screen matches Figma height', () {
      _initMobile();
      expect(ResKit.scaleH, closeTo(1.0, 1e-6));
    });

    test('scaleW == 2.0 on a 780-wide screen (figma 390)', () {
      _initAt(const Size(780, 844),
          config: const ResKitConfig(figmaWidth: 390, figmaHeight: 844));
      expect(ResKit.scaleW, closeTo(2.0, 1e-6));
    });

    test('scale == min(scaleW, scaleH)', () {
      _initAt(const Size(780, 844),
          config: const ResKitConfig(figmaWidth: 390, figmaHeight: 844));
      expect(ResKit.scale, closeTo(1.0, 1e-6)); // scaleH = 1.0
    });

    test('textScale clamped by maxFontScale', () {
      _initAt(const Size(780, 844),
          config: const ResKitConfig(
              figmaWidth: 390, figmaHeight: 844, maxFontScale: 1.3));
      expect(ResKit.textScale, lessThanOrEqualTo(1.3));
    });

    test('textScale unclamped when maxFontScale is null', () {
      _initAt(const Size(780, 844),
          config: const ResKitConfig(
              figmaWidth: 390, figmaHeight: 844, maxFontScale: null));
      expect(ResKit.textScale, closeTo(1.0, 1e-6)); // min(2,1)=1
    });
  });

  // ── 2. Core sizing API ───────────────────────────────────────────────────
  group('ResKit — sizing API', () {
    setUp(_initMobile);

    test('width() == value * scaleW', () {
      expect(ResKit.width(200), closeTo(200 * ResKit.scaleW, 1e-6));
    });
    test('height() == value * scaleH', () {
      expect(ResKit.height(100), closeTo(100 * ResKit.scaleH, 1e-6));
    });
    test('radius() == value * scale', () {
      expect(ResKit.radius(12), closeTo(12 * ResKit.scale, 1e-6));
    });
    test('sp() == value * textScale', () {
      expect(ResKit.sp(16), closeTo(16 * ResKit.textScale, 1e-6));
    });
    test('dp() is passthrough', () {
      expect(ResKit.dp(42), 42.0);
    });
    test('sw(0.5) == screenWidth * 0.5', () {
      expect(ResKit.sw(0.5), closeTo(ResKit.screenWidth * 0.5, 1e-6));
    });
    test('sh(0.1) == screenHeight * 0.1', () {
      expect(ResKit.sh(0.1), closeTo(ResKit.screenHeight * 0.1, 1e-4));
    });
    test('all() returns symmetric EdgeInsets', () {
      final ei = ResKit.all(16);
      expect(ei.left, closeTo(ei.right, 1e-6));
      expect(ei.top,  closeTo(ei.bottom, 1e-6));
    });
    test('symmetric() returns correct insets', () {
      final a = ResKit.symmetric(vertical: 8, horizontal: 16);
      expect(a.top,  closeTo(ResKit.height(8),  1e-6));
      expect(a.left, closeTo(ResKit.width(16),  1e-6));
    });
  });

  // ── 3. Fluid typography ──────────────────────────────────────────────────
  group('ResKit — fluidSp', () {
    test('returns minSp when at minWidth', () {
      _initAt(const Size(480, 844),
          config: const ResKitConfig(figmaWidth: 480, figmaHeight: 844));
      final v = ResKit.fluidSp(minSp: 14, maxSp: 28, minWidth: 480, maxWidth: 1440);
      // factor=0 → v = sp(14) = 14 * textScale
      expect(v, closeTo(ResKit.sp(14), 1e-4));
    });

    test('returns maxSp when at maxWidth', () {
      _initAt(const Size(1440, 900),
          config: const ResKitConfig(figmaWidth: 1440, figmaHeight: 900));
      final v = ResKit.fluidSp(minSp: 14, maxSp: 28, minWidth: 480, maxWidth: 1440);
      expect(v, closeTo(ResKit.sp(28), 1e-4));
    });

    test('interpolates between min and max', () {
      // screen = 960 px, range 480–1440 → factor = (960-480)/(1440-480) = 0.5
      _initAt(const Size(960, 844),
          config: const ResKitConfig(figmaWidth: 960, figmaHeight: 844));
      final v = ResKit.fluidSp(minSp: 14, maxSp: 28, minWidth: 480, maxWidth: 1440);
      final expected = ResKit.sp(14 + (28 - 14) * 0.5); // sp(21)
      expect(v, closeTo(expected, 1e-4));
    });
  });

  // ── 4. Num extensions ────────────────────────────────────────────────────
  group('Num extensions', () {
    setUp(_initMobile);

    test('.w == ResKit.width()', ()  => expect(200.w,  ResKit.width(200)));
    test('.h == ResKit.height()', () => expect(100.h,  ResKit.height(100)));
    test('.r == ResKit.radius()', () => expect(12.r,   ResKit.radius(12)));
    test('.sp == ResKit.sp()',    () => expect(16.sp,  ResKit.sp(16)));
    test('.sw == ResKit.sw()',    () => expect(0.5.sw, ResKit.sw(0.5)));
    test('.sh == ResKit.sh()',    () => expect(0.1.sh, ResKit.sh(0.1)));
    test('.dp == passthrough',   () => expect(8.dp,   8.0));
    test('.pt == passthrough',   () => expect(8.pt,   8.0));
  });

  // ── 5. Breakpoints ───────────────────────────────────────────────────────
  group('ResKit — breakpoints', () {
    test('mobile screen: isMobile=true, isTablet=false, isDesktop=false', () {
      _initAt(const Size(390, 844));
      expect(ResKit.isMobile,  isTrue);
      expect(ResKit.isTablet,  isFalse);
      expect(ResKit.isDesktop, isFalse);
    });

    test('tablet screen: isTablet=true', () {
      _initAt(const Size(800, 1024));
      expect(ResKit.isMobile,  isFalse);
      expect(ResKit.isTablet,  isTrue);
      expect(ResKit.isDesktop, isFalse);
    });

    test('desktop screen: isDesktop=true', () {
      _initAt(const Size(1280, 900));
      expect(ResKit.isMobile,  isFalse);
      expect(ResKit.isTablet,  isFalse);
      expect(ResKit.isDesktop, isTrue);
    });

    test('isDesktopLarge: true at 1440', () {
      _initAt(const Size(1440, 900));
      expect(ResKit.isDesktopLarge, isTrue);
    });

    test('isDesktopXL: true at 1920', () {
      _initAt(const Size(1920, 1080));
      expect(ResKit.isDesktopXL, isTrue);
    });

    test('isMobileSmall: true at 360', () {
      _initAt(const Size(360, 780));
      expect(ResKit.isMobileSmall, isTrue);
    });
  });

  // ── 6. Adaptive helper ───────────────────────────────────────────────────
  group('ResKit.adaptive()', () {
    test('mobile → returns mobile', () {
      _initMobile();
      expect(ResKit.adaptive(mobile: 1, tablet: 2, desktop: 4), 1);
    });
    test('tablet → returns tablet', () {
      _initAt(const Size(800, 1024));
      expect(ResKit.adaptive(mobile: 1, tablet: 2, desktop: 4), 2);
    });
    test('desktop → returns desktop', () {
      _initDesktop();
      expect(ResKit.adaptive(mobile: 1, tablet: 2, desktop: 4), 4);
    });
    test('desktop fallback to tablet when desktop omitted', () {
      _initDesktop();
      expect(ResKit.adaptive(mobile: 1, tablet: 2), 2);
    });
  });

  // ── 7. Multi-canvas design config ────────────────────────────────────────
  group('ResKitDesignConfig', () {
    final multiConfig = ResKitConfig(
      designs: ResKitDesignConfig(
        mobile:  ResKitDesignSize.iphone14,    // 390×844
        tablet:  ResKitDesignSize.ipadMini,    // 768×1024
        desktop: ResKitDesignSize.macbookAir,  // 1440×900
      ),
    );

    test('resolves mobile canvas on mobile screen', () {
      _initAt(const Size(390, 844), config: multiConfig);
      expect(ResKit.figmaWidth,  closeTo(390,  1e-6));
      expect(ResKit.figmaHeight, closeTo(844,  1e-6));
    });

    test('resolves tablet canvas on 800-wide screen', () {
      _initAt(const Size(800, 1024), config: multiConfig);
      expect(ResKit.figmaWidth,  closeTo(768,  1e-6));
      expect(ResKit.figmaHeight, closeTo(1024, 1e-6));
    });

    test('resolves desktop canvas on 1440-wide screen', () {
      _initAt(const Size(1440, 900), config: multiConfig);
      expect(ResKit.figmaWidth,  closeTo(1440, 1e-6));
      expect(ResKit.figmaHeight, closeTo(900,  1e-6));
    });

    test('activeDesign reflects current canvas', () {
      _initAt(const Size(768, 1024), config: multiConfig);
      expect(ResKit.activeDesign, ResKitDesignSize.ipadMini);
    });
  });

  // ── 8. Typography ────────────────────────────────────────────────────────
  group('ResKitTypography', () {
    setUp(_initMobile);

    test('h1 fontSize > h6 fontSize', () {
      final h1 = ResKitTypography.h1().fontSize!;
      final h6 = ResKitTypography.h6().fontSize!;
      expect(h1, greaterThan(h6));
    });

    test('display fontSize > h1 fontSize', () {
      final d  = ResKitTypography.display().fontSize!;
      final h1 = ResKitTypography.h1().fontSize!;
      expect(d, greaterThan(h1));
    });

    test('body has line height ≥ 1.4', () {
      expect(ResKitTypography.body().height, greaterThanOrEqualTo(1.4));
    });

    test('caption is smaller than body', () {
      final cap  = ResKitTypography.caption().fontSize!;
      final body = ResKitTypography.body().fontSize!;
      expect(cap, lessThan(body));
    });

    test('custom() scales arbitrary size', () {
      final style = ResKitTypography.custom(20);
      expect(style.fontSize, closeTo(ResKit.sp(20), 1e-6));
    });

    test('fluid() returns size between min and max', () {
      final style = ResKitTypography.fluid(minSp: 14, maxSp: 28);
      expect(style.fontSize!, inInclusiveRange(ResKit.sp(14), ResKit.sp(28) + 0.01));
    });
  });

  // ── 9. ResKitTextTheme ───────────────────────────────────────────────────
  group('ResKitTextTheme', () {
    setUp(_initMobile);

    test('build() returns a non-null TextTheme', () {
      final tt = ResKitTextTheme.build();
      expect(tt.bodyMedium, isNotNull);
      expect(tt.headlineLarge, isNotNull);
    });

    test('merge() scales all non-null font sizes', () {
      const base = TextTheme(
        bodyMedium: TextStyle(fontSize: 14),
        headlineLarge: TextStyle(fontSize: 32),
      );
      final merged = ResKitTextTheme.merge(base);
      expect(merged.bodyMedium!.fontSize, closeTo(ResKit.sp(14), 1e-6));
      expect(merged.headlineLarge!.fontSize, closeTo(ResKit.sp(32), 1e-6));
    });
  });

  // ── 10. Spacing tokens ───────────────────────────────────────────────────
  group('ResKitSpacing', () {
    setUp(_initMobile);

    test('xs < sm < md < lg < xl', () {
      expect(ResKitSpacing.xs, lessThan(ResKitSpacing.sm));
      expect(ResKitSpacing.sm, lessThan(ResKitSpacing.md));
      expect(ResKitSpacing.md, lessThan(ResKitSpacing.lg));
      expect(ResKitSpacing.lg, lessThan(ResKitSpacing.xl));
    });

    test('spacing is larger on desktop', () {
      final mobileMd = ResKitSpacing.md;
      _initDesktop();
      final desktopMd = ResKitSpacing.md;
      expect(desktopMd, greaterThan(mobileMd));
    });

    test('raw ignores breakpoint multiplier', () {
      final raw = ResKitSpacing.raw(16);
      expect(raw, closeTo(ResKit.radius(16), 1e-6));
    });
  });

  // ── 11. ResKitInsets ─────────────────────────────────────────────────────
  group('ResKitInsets', () {
    test('pagePadding horizontal is larger on desktop than mobile', () {
      _initMobile();
      final mobileH = ResKitInsets.pagePadding.horizontal;
      _initDesktop();
      final desktopH = ResKitInsets.pagePadding.horizontal;
      expect(desktopH, greaterThan(mobileH));
    });

    test('gap widgets have non-zero size', () {
      _initMobile();
      final gap = ResKitInsets.gapMd;
      expect((gap.height ?? 0), greaterThan(0));
    });
  });

  // ── 12. ResKitDesignSize presets ─────────────────────────────────────────
  group('ResKitDesignSize presets', () {
    test('iphone14 is 390×844', () {
      expect(ResKitDesignSize.iphone14.width,  390);
      expect(ResKitDesignSize.iphone14.height, 844);
    });
    test('ipadMini is 768×1024', () {
      expect(ResKitDesignSize.ipadMini.width,  768);
      expect(ResKitDesignSize.ipadMini.height, 1024);
    });
    test('macbookAir is 1440×900', () {
      expect(ResKitDesignSize.macbookAir.width,  1440);
      expect(ResKitDesignSize.macbookAir.height, 900);
    });
    test('fullHD is 1920×1080', () {
      expect(ResKitDesignSize.fullHD.width,  1920);
      expect(ResKitDesignSize.fullHD.height, 1080);
    });
  });

  // ── 13. ResKitBreakpoints presets ────────────────────────────────────────
  group('ResKitBreakpoints presets', () {
    test('default mobile breakpoint is 480', () {
      expect(const ResKitBreakpoints().mobile, 480);
    });
    test('bootstrap mobile breakpoint is 576', () {
      expect(ResKitBreakpoints.bootstrap().mobile, 576);
    });
    test('tailwind desktopLarge is 1280', () {
      expect(ResKitBreakpoints.tailwind().desktopLarge, 1280);
    });
  });

  // ── 14. ResKitPlatform ───────────────────────────────────────────────────
  group('ResKitPlatform', () {
    test('exactly one OS flag is true', () {
      final flags = [
        ResKitPlatform.isAndroid, ResKitPlatform.isIOS,
        ResKitPlatform.isWeb,     ResKitPlatform.isMacOS,
        ResKitPlatform.isWindows, ResKitPlatform.isLinux,
        ResKitPlatform.isFuchsia,
      ];
      expect(flags.where((f) => f).length, 1);
    });

    test('isNativeMobile == isAndroid || isIOS', () {
      expect(ResKitPlatform.isNativeMobile,
          ResKitPlatform.isAndroid || ResKitPlatform.isIOS);
    });

    test('isNativeDesktop == isMacOS || isWindows || isLinux', () {
      expect(ResKitPlatform.isNativeDesktop,
          ResKitPlatform.isMacOS || ResKitPlatform.isWindows || ResKitPlatform.isLinux);
    });
  });

  // ── 15. ResKitUtils ──────────────────────────────────────────────────────
  group('ResKitUtils', () {
    setUp(_initMobile);

    test('gridItemWidth: 2 cols no spacing = half screen', () {
      expect(ResKitUtils.gridItemWidth(columns: 2, spacing: 0),
          closeTo(ResKit.screenWidth / 2, 1e-6));
    });

    test('adaptiveColumns ≥ 1', () {
      expect(ResKitUtils.adaptiveColumns(minItemWidth: 9999),
          greaterThanOrEqualTo(1));
    });

    test('usableHeight ≤ screenHeight', () {
      expect(ResKitUtils.usableHeight, lessThanOrEqualTo(ResKit.screenHeight));
    });

    test('clampWidth respects bounds', () {
      final v = ResKitUtils.clampWidth(500, min: 100, max: 200);
      expect(v, lessThanOrEqualTo(ResKit.width(200) + 1e-6));
    });

    test('aspectFitWidth preserves ratio', () {
      final s = ResKitUtils.aspectFitWidth(figmaWidth: 320, figmaHeight: 160);
      expect(s.width / s.height, closeTo(2.0, 1e-4));
    });

    test('diagnosticMap contains required keys', () {
      final map = ResKitUtils.diagnosticMap();
      expect(map, containsPair('screenWidth', isA<double>()));
      expect(map, containsPair('isMobile', isA<bool>()));
      expect(map, containsPair('platform', isA<String>()));
    });
  });

  // ── 16. ResKitTestHelper ─────────────────────────────────────────────────
  group('ResKitTestHelper', () {
    test('init() sets up ResKit correctly', () {
      ResKitTestHelper.init(size: ResKitTestSizes.ipadMini);
      expect(ResKit.screenWidth,  768);
      expect(ResKit.screenHeight, 1024);
    });

    test('initMobile sets mobile screen', () {
      ResKitTestHelper.initMobile();
      expect(ResKit.isMobile, isTrue);
    });

    test('initTablet sets tablet screen', () {
      ResKitTestHelper.initTablet();
      expect(ResKit.isTablet, isTrue);
    });

    test('initDesktop sets desktop screen', () {
      ResKitTestHelper.initDesktop();
      expect(ResKit.isDesktop, isTrue);
    });
  });

  // ── 17. ResKitConfig.resolveDesign ──────────────────────────────────────
  group('ResKitConfig.resolveDesign', () {
    final cfg = ResKitConfig(
      designs: ResKitDesignConfig(
        mobile:  const ResKitDesignSize(width: 390,  height: 844),
        tablet:  const ResKitDesignSize(width: 768,  height: 1024),
        desktop: const ResKitDesignSize(width: 1440, height: 900),
        web:     const ResKitDesignSize(width: 1280, height: 800),
      ),
    );

    test('resolves web canvas when isWeb', () {
      final d = cfg.resolveDesign(screenWidth: 1440, isWeb: true);
      expect(d.width,  1280);
      expect(d.height, 800);
    });

    test('resolves desktop canvas on 1440 non-web', () {
      final d = cfg.resolveDesign(screenWidth: 1440, isWeb: false);
      expect(d.width,  1440);
      expect(d.height, 900);
    });

    test('resolves tablet canvas on 768', () {
      final d = cfg.resolveDesign(screenWidth: 768, isWeb: false);
      expect(d.width,  768);
      expect(d.height, 1024);
    });

    test('resolves mobile canvas on 390', () {
      final d = cfg.resolveDesign(screenWidth: 390, isWeb: false);
      expect(d.width,  390);
      expect(d.height, 844);
    });
  });

  // ── 18. ResKitAccessibility ──────────────────────────────────────────────
  group('ResKitAccessibility', () {
    setUp(_initMobile);

    test('duration returns zero when reducedMotion unavailable (default false)', () {
      // Default MediaQueryData has disableAnimations=false
      final dur = ResKitAccessibility.duration(const Duration(milliseconds: 300));
      expect(dur.inMilliseconds, 300);
    });

    test('minTapTarget ≥ 44 dp (WCAG guideline)', () {
      expect(ResKitAccessibility.minTapTarget, greaterThanOrEqualTo(44));
    });
  });

  // ── 19. ResKitThemeExtension ─────────────────────────────────────────────
  group('ResKitThemeExtension', () {
    setUp(_initMobile);

    test('fromResKit returns non-null tokens', () {
      final ext = ResKitThemeExtension.fromResKit();
      expect(ext.cardRadius,            isNotNull);
      expect(ext.buttonRadius,          isNotNull);
      expect(ext.pageHorizontalPadding, isNotNull);
      expect(ext.sectionSpacing,        isNotNull);
    });

    test('copyWith overrides individual values', () {
      final ext  = ResKitThemeExtension.fromResKit();
      final copy = ext.copyWith(cardRadius: 99);
      expect(copy.cardRadius,   99);
      expect(copy.buttonRadius, ext.buttonRadius);
    });

    test('lerp interpolates between two extensions', () {
      final a = const ResKitThemeExtension(cardRadius: 0);
      final b = const ResKitThemeExtension(cardRadius: 10);
      final mid = a.lerp(b, 0.5);
      expect(mid.cardRadius, closeTo(5.0, 1e-6));
    });
  });

  // ── 20. ResKit.directional ───────────────────────────────────────────────
  group('ResKit — RTL helpers', () {
    setUp(_initMobile);

    test('directional start is scaled width', () {
      final ei = ResKit.directional(start: 16, end: 8);
      expect(ei.start, closeTo(ResKit.width(16), 1e-6));
      expect(ei.end,   closeTo(ResKit.width(8),  1e-6));
    });
  });
}
