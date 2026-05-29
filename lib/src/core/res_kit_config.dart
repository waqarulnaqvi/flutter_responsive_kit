import 'res_kit_breakpoints.dart';
import 'res_kit_design_config.dart';

class ResKitConfig {
  // Single-canvas fallback
  final double figmaWidth;
  final double figmaHeight;
  // Multi-canvas
  final ResKitDesignConfig? designs;
  // Scaling
  final bool splitScaleAxes;
  final double? maxFontScale;
  // Breakpoints
  final ResKitBreakpoints breakpoints;
  // Behaviour
  final bool adaptToOrientation;
  final bool useSystemTextScale;
  // Typography
  final double baseLineHeight;
  final double baseLetterSpacing;

  const ResKitConfig({
    this.figmaWidth        = 390,
    this.figmaHeight       = 844,
    this.designs,
    this.splitScaleAxes    = true,
    this.maxFontScale      = 1.4,
    this.breakpoints       = const ResKitBreakpoints(),
    this.adaptToOrientation = true,
    this.useSystemTextScale = false,
    this.baseLineHeight    = 1.5,
    this.baseLetterSpacing = 0.0,
  });

  ResKitDesignSize resolveDesign({required double screenWidth, required bool isWeb}) {
    if (designs != null) {
      return designs!.resolve(screenWidth: screenWidth, isWebPlatform: isWeb, bp: breakpoints);
    }
    return ResKitDesignSize(width: figmaWidth, height: figmaHeight);
  }

  ResKitConfig copyWith({
    double? figmaWidth, double? figmaHeight, ResKitDesignConfig? designs,
    bool? splitScaleAxes, double? maxFontScale, ResKitBreakpoints? breakpoints,
    bool? adaptToOrientation, bool? useSystemTextScale,
    double? baseLineHeight, double? baseLetterSpacing,
  }) => ResKitConfig(
    figmaWidth: figmaWidth ?? this.figmaWidth,
    figmaHeight: figmaHeight ?? this.figmaHeight,
    designs: designs ?? this.designs,
    splitScaleAxes: splitScaleAxes ?? this.splitScaleAxes,
    maxFontScale: maxFontScale ?? this.maxFontScale,
    breakpoints: breakpoints ?? this.breakpoints,
    adaptToOrientation: adaptToOrientation ?? this.adaptToOrientation,
    useSystemTextScale: useSystemTextScale ?? this.useSystemTextScale,
    baseLineHeight: baseLineHeight ?? this.baseLineHeight,
    baseLetterSpacing: baseLetterSpacing ?? this.baseLetterSpacing,
  );
}
