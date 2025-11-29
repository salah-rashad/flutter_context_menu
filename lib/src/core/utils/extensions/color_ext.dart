import 'dart:ui';

extension ColorExtensions on Color {
  Color applyOpacity(double opacity) {
    return withValues(alpha: opacity.clamp(0, 1));
  }

  Color blendOn(Color background, double alpha) {
    return Color.alphaBlend(applyOpacity(alpha), background);
  }
}
