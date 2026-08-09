# Quickstart: Checkable/Toggle Menu Entry

**Feature**: 003-checkable-entry

## Basic Usage

```dart
import 'package:flutter_context_menu/flutter_context_menu.dart';

// In a StatefulWidget:
bool showGrid = false;
bool snapToGuides = true;
bool autoSave = false;

final menu = ContextMenu(
  entries: [
    MenuItem(
      label: const Text('Cut'),
      value: 'cut',
      icon: const Icon(Icons.cut),
    ),
    const MenuDivider(),
    const MenuHeader(text: 'View Options'),
    CheckableMenuItem(
      label: const Text('Show grid'),
      checked: showGrid,
      onToggle: (value) => setState(() => showGrid = value),
    ),
    CheckableMenuItem(
      label: const Text('Snap to guides'),
      checked: snapToGuides,
      onToggle: (value) => setState(() => snapToGuides = value),
    ),
    CheckableMenuItem(
      label: const Text('Auto-save'),
      checked: autoSave,
      onToggle: (value) => setState(() => autoSave = value),
    ),
  ],
  position: Offset.zero,
);
```

## With Custom Check Indicator

```dart
CheckableMenuItem(
  label: const Text('Dark mode'),
  icon: const Icon(Icons.dark_mode),  // Replaces default checkmark when checked
  checked: isDarkMode,
  onToggle: (value) => setState(() => isDarkMode = value),
)
```

## Disabled Checkable Entry

```dart
CheckableMenuItem(
  label: const Text('Premium feature'),
  checked: false,
  enabled: false,  // Visually dimmed, not toggleable
  onToggle: (value) {},
)
```

## With Keyboard Shortcut Display

```dart
CheckableMenuItem(
  label: const Text('Show grid'),
  checked: showGrid,
  onToggle: (value) => setState(() => showGrid = value),
  shortcut: const SingleActivator(LogicalKeyboardKey.keyG, control: true),
)
```

## Custom Checkable Entry (Subclassing)

```dart
final class ToggleSwitchMenuItem<T> extends ContextMenuCheckableItem<T> {
  final Widget label;

  const ToggleSwitchMenuItem({
    required this.label,
    super.checked,
    super.onToggle,
    super.enabled,
  });

  @override
  Widget builder(BuildContext context, ContextMenuState<T> menuState,
      [FocusNode? focusNode]) {
    // Custom visual — e.g., a switch-style toggle instead of checkmark
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(child: label),
          Switch(value: checked, onChanged: null), // Visual only
        ],
      ),
    );
  }
}
```
