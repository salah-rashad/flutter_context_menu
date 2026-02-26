import 'package:shadcn_flutter/shadcn_flutter.dart';

/// App-level settings state.
///
/// Contains application-wide configuration such as theme mode.
class AppSettingsState {
  /// The current theme mode (light, dark, or system).
  ThemeMode themeMode;

  /// Creates app settings with optional theme mode.
  AppSettingsState({
    this.themeMode = ThemeMode.dark,
  });

  /// Creates a copy of this state with the given fields replaced.
  AppSettingsState copyWith({
    ThemeMode? themeMode,
  }) {
    return AppSettingsState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Sets the theme mode.
  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
  }
}
