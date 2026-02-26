import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'app_settings_state.dart';

/// Central state object for the context menu playground.
///
/// Manages all menu configuration, styling, and app settings.
/// Exposed via [ChangeNotifierProvider] at the app root.
///
/// This is a minimal implementation for Phase 1 setup.
/// Full implementation will be completed in Phase 2.
class PlaygroundState extends ChangeNotifier {
  /// App-level settings (theme mode, etc.).
  AppSettingsState appSettings;

  /// Creates playground state with default values.
  PlaygroundState({
    AppSettingsState? appSettings,
  }) : appSettings = appSettings ?? AppSettingsState();

  /// Sets the theme mode and notifies listeners.
  void setThemeMode(ThemeMode mode) {
    appSettings.setThemeMode(mode);
    notifyListeners();
  }
}
