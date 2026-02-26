import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
// ignore: implementation_imports
import 'package:flutter_context_menu/src/widgets/base/context_menu_widget.dart';
import 'package:provider/provider.dart';

import '../state/entry_node.dart';
import '../state/playground_state.dart';

/// A widget that embeds a context menu directly in the widget tree
/// for always-visible, non-dismissible display.
///
/// This widget creates a [ContextMenuState] from [PlaygroundState.buildContextMenu],
/// places the menu inside a [Stack], and intercepts dismissal actions
/// to keep the menu visible at all times.
///
/// Key behaviors:
/// - Menu cannot be dismissed by clicking outside
/// - Escape key does not close the menu
/// - Item selection updates [PlaygroundState.lastSelectedValue] without dismissal
/// - State is recreated when entries change
class EmbeddedContextMenu extends StatefulWidget {
  /// Creates an embedded context menu widget.
  const EmbeddedContextMenu({
    super.key,
    required this.position,
  });

  /// The position where the context menu should appear.
  final Offset position;

  @override
  State<EmbeddedContextMenu> createState() => _EmbeddedContextMenuState();
}

class _EmbeddedContextMenuState extends State<EmbeddedContextMenu> {
  ContextMenuState<String>? _menuState;
  int _lastEntriesHash = 0;
  ContextMenuStyle? _lastStyle;
  Clip? _lastClipBehavior;
  bool? _lastRespectPadding;

  @override
  void didUpdateWidget(EmbeddedContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      _recreateMenuState();
    }
  }

  /// Updates the menu state if entries or style have changed.
  void _updateMenuStateIfNeeded(PlaygroundState playgroundState) {
    final newHash = _computeEntriesHash(playgroundState.entries);
    final newStyle = playgroundState.buildInlineStyle();
    final newClipBehavior = playgroundState.menuProperties.clipBehavior;
    final newRespectPadding = playgroundState.menuProperties.respectPadding;

    // Check if entries or configuration have changed
    if (_lastEntriesHash != newHash ||
        _lastStyle != newStyle ||
        _lastClipBehavior != newClipBehavior ||
        _lastRespectPadding != newRespectPadding) {
      _lastEntriesHash = newHash;
      _lastStyle = newStyle;
      _lastClipBehavior = newClipBehavior;
      _lastRespectPadding = newRespectPadding;
      _recreateMenuState();
    }
  }

  /// Computes a hash for the entries list to detect changes.
  ///
  /// Uses [EntryNode.hashCode] which covers all fields, ensuring
  /// any property change triggers a menu state recreation.
  int _computeEntriesHash(List<EntryNode> entries) {
    int hash = 0;
    for (final entry in entries) {
      hash = Object.hash(hash, entry.hashCode);
      if (entry.children.isNotEmpty) {
        hash = Object.hash(hash, _computeEntriesHash(entry.children));
      }
    }
    return hash;
  }

  /// Recreates the menu state with current configuration.
  void _recreateMenuState() {
    final playgroundState = context.read<PlaygroundState>();

    // Dispose old state if exists
    _menuState?.dispose();

    // Create new menu with current configuration
    final menu = playgroundState.buildContextMenu().copyWith(
          position: widget.position,
        );

    _menuState = ContextMenuState<String>(
      menu: menu,
      onItemSelected: (value) {
        // Update last selected value without dismissing
        playgroundState.setLastSelectedValue(value);
      },
    );

    setState(() {});
  }

  @override
  void dispose() {
    _menuState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch here so Flutter's standard rebuild cycle drives change detection.
    final playgroundState = context.watch<PlaygroundState>();
    _updateMenuStateIfNeeded(playgroundState);

    if (_menuState == null) {
      return const SizedBox.shrink();
    }

    return _EmbeddedMenuView(
      menuState: _menuState!,
    );
  }
}

/// A custom view widget that renders the context menu without dismissal behavior.
///
/// This widget wraps [ContextMenuWidget] directly in a [Stack].
/// Position is controlled entirely by [ContextMenuState.position].
class _EmbeddedMenuView extends StatelessWidget {
  const _EmbeddedMenuView({
    required this.menuState,
  });

  final ContextMenuState<String> menuState;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ContextMenuWidget(
          menuState: menuState,
        ),
      ],
    );
  }
}
