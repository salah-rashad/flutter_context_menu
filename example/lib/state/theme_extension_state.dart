import 'inline_style_state.dart';

/// State for the ThemeData.extensions configuration.
///
/// When [enabled] is true, the [style] is added to [ThemeData.extensions]
/// as a [ContextMenuStyle] theme extension.
class ThemeExtensionState {
  /// Whether to add style to ThemeData.extensions.
  final bool enabled;

  /// Style values (same shape as InlineStyleState).
  final InlineStyleState style;

  /// Creates theme extension state.
  const ThemeExtensionState({
    this.enabled = false,
    this.style = const InlineStyleState.empty(),
  });

  /// Creates a copy of this state with the given fields replaced.
  ThemeExtensionState copyWith({
    bool? enabled,
    InlineStyleState? style,
  }) {
    return ThemeExtensionState(
      enabled: enabled ?? this.enabled,
      style: style ?? this.style,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeExtensionState &&
        other.enabled == enabled &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(enabled, style);

  @override
  String toString() {
    return 'ThemeExtensionState(enabled: $enabled, style: $style)';
  }
}
