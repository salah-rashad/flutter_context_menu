import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

/// Resolves a [ThemeMode] to a [Brightness] based on the current platform brightness.
///
/// This helper centralizes the theme mode → brightness conversion logic
/// to avoid duplication across multiple widgets.
Brightness resolvedBrightness(
  BuildContext context,
  ThemeMode themeMode,
) {
  return switch (themeMode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    ThemeMode.system => MediaQuery.platformBrightnessOf(context),
  };
}

/// Builds a Material [ThemeData] from the current shadcn_flutter color context.
///
/// This function creates a Material theme that matches the shadcn_flutter
/// appearance, optionally including a [ContextMenuStyle] extension.
///
/// The [brightness] parameter determines whether to use light or dark colors.
/// The [contextMenuStyle] parameter, when provided, is added to the theme extensions.
ThemeData buildMaterialTheme({
  required Brightness brightness,
  ContextMenuStyle? contextMenuStyle,
}) {
  // Define color schemes based on brightness
  final colorScheme = brightness == Brightness.light
      ? ColorScheme.fromSeed(
          seedColor: const Color(0xFF18181B), // Zinc-900
          brightness: brightness,
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF18181B),
        )
      : ColorScheme.fromSeed(
          seedColor: const Color(0xFFFAFAFA), // Zinc-50
          brightness: brightness,
          surface: const Color(0xFF09090B), // Zinc-950
          onSurface: const Color(0xFFFAFAFA),
        );

  // Build extensions list
  final extensions = <ThemeExtension<dynamic>>[
    if (contextMenuStyle != null) contextMenuStyle,
  ];

  return ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    useMaterial3: true,
    extensions: extensions,
    // Match shadcn_flutter typography
    textTheme: Typography.material2021().black.copyWith(
          bodyMedium: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          labelMedium: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
    // Shadow configuration
    shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
    // Divider theme
    dividerTheme: DividerThemeData(
      color: colorScheme.onSurface.withValues(alpha: 0.1),
      thickness: 0.0,
      space: 8.0,
    ),
  );
}

/// Extension to get brightness-aware surface colors.
extension BrightnessColors on Brightness {
  /// Returns the appropriate surface color for this brightness.
  Color get surfaceColor => this == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF09090B);

  /// Returns the appropriate on-surface color for this brightness.
  Color get onSurfaceColor => this == Brightness.light
      ? const Color(0xFF18181B)
      : const Color(0xFFFAFAFA);

  /// Returns the appropriate border color for this brightness.
  Color get borderColor => this == Brightness.light
      ? const Color(0xFFE4E4E7) // Zinc-200
      : const Color(0xFF27272A); // Zinc-800

  /// Returns the appropriate muted color for this brightness.
  Color get mutedColor => this == Brightness.light
      ? const Color(0xFFF4F4F5) // Zinc-100
      : const Color(0xFF18181B); // Zinc-900
}
