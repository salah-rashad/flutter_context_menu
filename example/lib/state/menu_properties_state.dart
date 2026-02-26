import 'dart:ui';

/// State for ContextMenu-level properties.
///
/// These properties are passed directly to the [ContextMenu] widget
/// and control behavior like clipping and padding handling.
class MenuPropertiesState {
  /// Menu clip behavior.
  final Clip clipBehavior;

  /// Whether to respect padding for submenus.
  final bool respectPadding;

  /// Creates menu properties state.
  const MenuPropertiesState({
    this.clipBehavior = Clip.antiAlias,
    this.respectPadding = true,
  });

  /// Creates a copy of this state with the given fields replaced.
  MenuPropertiesState copyWith({
    Clip? clipBehavior,
    bool? respectPadding,
  }) {
    return MenuPropertiesState(
      clipBehavior: clipBehavior ?? this.clipBehavior,
      respectPadding: respectPadding ?? this.respectPadding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MenuPropertiesState &&
        other.clipBehavior == clipBehavior &&
        other.respectPadding == respectPadding;
  }

  @override
  int get hashCode => Object.hash(clipBehavior, respectPadding);

  @override
  String toString() {
    return 'MenuPropertiesState(clipBehavior: $clipBehavior, respectPadding: $respectPadding)';
  }
}
