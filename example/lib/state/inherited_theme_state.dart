import 'inline_style_state.dart';

/// State for the ContextMenuTheme wrapper configuration.
///
/// When [enabled] is true, the context menu is wrapped in a
/// [ContextMenuTheme] widget with the provided [style].
class InheritedThemeState {
  /// Whether to wrap menu in ContextMenuTheme.
  final bool enabled;

  /// Style values (same shape as InlineStyleState).
  final InlineStyleState style;

  /// Creates inherited theme state.
  const InheritedThemeState({
    this.enabled = false,
    this.style = const InlineStyleState.empty(),
  });

  /// Creates a copy of this state with the given fields replaced.
  InheritedThemeState copyWith({
    bool? enabled,
    InlineStyleState? style,
  }) {
    return InheritedThemeState(
      enabled: enabled ?? this.enabled,
      style: style ?? this.style,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InheritedThemeState &&
        other.enabled == enabled &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(enabled, style);

  @override
  String toString() {
    return 'InheritedThemeState(enabled: $enabled, style: $style)';
  }
}
