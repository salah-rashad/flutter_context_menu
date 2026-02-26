# Quickstart: Example Playground

**Feature**: 002-example-playground
**Date**: 2026-02-26

## Prerequisites

- Flutter SDK >=3.27.0
- Dart SDK ^3.6.0
- Chrome browser (primary target)

## Setup

```bash
cd example
flutter pub get
flutter run -d chrome
```

## Project Structure

```
example/
├── lib/
│   ├── main.dart                          # ShadcnApp entry point
│   ├── app.dart                           # App widget with theme management
│   ├── state/
│   │   ├── playground_state.dart          # Central ChangeNotifier
│   │   ├── entry_node.dart                # Menu entry tree node model
│   │   ├── menu_properties_state.dart     # ContextMenu-level properties
│   │   ├── inline_style_state.dart        # Inline ContextMenuStyle config
│   │   ├── inherited_theme_state.dart     # ContextMenuTheme wrapper config
│   │   ├── theme_extension_state.dart     # ThemeData.extensions config
│   │   ├── menu_item_style_state.dart     # MenuItemStyle sub-state
│   │   ├── menu_header_style_state.dart   # MenuHeaderStyle sub-state
│   │   ├── menu_divider_style_state.dart  # MenuDividerStyle sub-state
│   │   └── app_settings_state.dart        # App brightness mode
│   ├── screens/
│   │   └── playground_screen.dart         # Main split layout
│   ├── widgets/
│   │   ├── playground_area.dart           # Center area with embedded menu
│   │   ├── embedded_context_menu.dart     # Wraps ContextMenuWidget for always-on display
│   │   ├── tools_panel/
│   │   │   ├── tools_panel.dart           # Two-level tab container
│   │   │   ├── structure_tab/
│   │   │   │   ├── structure_tab.dart     # Structure tab layout
│   │   │   │   ├── entry_tree_editor.dart # Tree view for menu entries
│   │   │   │   ├── entry_node_tile.dart   # Single entry in tree
│   │   │   │   ├── entry_properties.dart  # Properties panel for selected entry
│   │   │   │   └── menu_properties.dart   # ContextMenu-level properties
│   │   │   └── theming_tab/
│   │   │       ├── theming_tab.dart       # Theming sub-tabs container
│   │   │       ├── inline_style_tab.dart  # Inline style controls
│   │   │       ├── inherited_theme_tab.dart # Inherited theme controls
│   │   │       ├── theme_extension_tab.dart # Theme extension controls
│   │   │       └── shared/
│   │   │           ├── style_editor.dart          # Reusable ContextMenuStyle editor
│   │   │           ├── menu_item_style_editor.dart   # MenuItemStyle controls
│   │   │           ├── menu_header_style_editor.dart  # MenuHeaderStyle controls
│   │   │           └── menu_divider_style_editor.dart # MenuDividerStyle controls
│   │   └── common/
│   │       ├── color_field.dart           # Color picker wrapper
│   │       ├── number_field.dart          # Numeric input with slider
│   │       ├── icon_picker.dart           # Predefined icon selector
│   │       └── section_header.dart        # Collapsible section header
│   └── utils/
│       ├── default_entries.dart           # Default sample menu entries
│       └── theme_bridge.dart             # shadcn_flutter ↔ Material theme bridge
├── pubspec.yaml
└── test/
    └── widget_test.dart                   # Smoke test
```

## Key Dependencies (example/pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_context_menu:
    path: ../
  shadcn_flutter: ^latest
  provider: ^latest
```

## Architecture Overview

```
ShadcnApp (root)
  └── ChangeNotifierProvider<PlaygroundState>
      └── PlaygroundScreen
          ├── ToolsPanel (left, ~350px resizable)
          │   ├── Tab: Structure
          │   │   ├── EntryTreeEditor
          │   │   └── MenuProperties
          │   └── Tab: Theming
          │       ├── Sub-tab: Inline Style
          │       ├── Sub-tab: Inherited Theme
          │       └── Sub-tab: Theme Extension
          └── PlaygroundArea (remaining space)
              └── Theme (Material bridge)
                  └── [ConditionalContextMenuTheme]
                      └── Stack
                          └── Center
                              └── EmbeddedContextMenu
                                  └── ContextMenuWidget<String>
```

## Theme Bridge Pattern

The context menu package resolves styles from `Theme.of(context).colorScheme`. Since the app uses `ShadcnApp`, we bridge the themes:

```dart
// Simplified — see theme_bridge.dart for full implementation
Theme(
  data: ThemeData(
    brightness: currentBrightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: shadcnPrimaryColor,
      brightness: currentBrightness,
    ),
    extensions: themeExtensionEnabled ? [themeExtensionStyle] : [],
  ),
  child: contextMenuArea,
)
```

## Embedded Menu Pattern

```dart
// Simplified — see embedded_context_menu.dart for full implementation
class EmbeddedContextMenu extends StatefulWidget {
  // Creates ContextMenuState manually
  // Places ContextMenuWidget in a Stack
  // Overrides onItemSelected to log value without dismissing
  // Recreates state when PlaygroundState.entries change
}
```
