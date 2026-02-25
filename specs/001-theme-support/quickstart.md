# Quickstart: Theme Support

**Feature Branch**: `001-theme-support`
**Date**: 2026-02-05

## Prerequisites

- Flutter >=3.27.0, Dart ^3.6.0
- `flutter_context_menu` package with theme support (version TBD)

## 1. App-Wide Theme via ThemeExtension (Recommended)

Define the context menu theme alongside your Material theme — no extra widget needed:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        extensions: const <ThemeExtension<dynamic>>[
          ContextMenuStyle(
            surfaceColor: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            padding: EdgeInsets.all(6.0),
            menuItemStyle: MenuItemStyle(
              height: 36.0,
              focusedBackgroundColor: Color(0xFFE3F2FD),
            ),
          ),
        ],
      ),
      darkTheme: ThemeData.dark().copyWith(
        extensions: const <ThemeExtension<dynamic>>[
          ContextMenuStyle(
            surfaceColor: Color(0xFF303030),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            menuItemStyle: MenuItemStyle(
              focusedBackgroundColor: Color(0xFF424242),
            ),
          ),
        ],
      ),
      home: const MyApp(),
    ),
  );
}
```

All context menus in the app now use these values. Light/dark switching works automatically.

## 2. App-Wide Theme via ContextMenuTheme Widget

Wrap your app (or a subtree) with the `ContextMenuTheme` widget:

```dart
ContextMenuTheme(
  data: const ContextMenuStyle(
    surfaceColor: Color(0xFFF5F5F5),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    menuItemStyle: MenuItemStyle(
      height: 36.0,
    ),
  ),
  child: const MyApp(),
)
```

## 3. Local Subtree Override

Override the theme for a specific section of the app:

```dart
// This subtree gets a different context menu style
ContextMenuTheme(
  data: const ContextMenuStyle(
    surfaceColor: Color(0xFFFFEBEE), // red-tinted
    menuItemStyle: MenuItemStyle(
      textColor: Color(0xFFC62828),
    ),
  ),
  child: const DangerZonePanel(),
)
```

## 4. Per-Menu Inline Override

Override specific properties on a single menu instance:

```dart
final menu = ContextMenu(
  entries: entries,
  position: const Offset(300, 300),
  // These override any theme values for this menu only:
  borderRadius: BorderRadius.circular(12.0),
  boxDecoration: BoxDecoration(
    color: Colors.amber.shade50,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.amber.withValues(alpha: 0.3),
        blurRadius: 16,
      ),
    ],
  ),
);
```

## 5. Customize Only What You Need

All theme properties are optional. Set only what you want to change:

```dart
// Only change item height and border radius — everything else stays default
const ContextMenuStyle(
  borderRadius: BorderRadius.all(Radius.circular(12.0)),
  menuItemStyle: MenuItemStyle(
    height: 40.0,
  ),
)
```

## Precedence Order

When multiple sources provide the same property, the most specific wins:

1. **Inline parameters** on `ContextMenu` / `MenuItem` (highest priority)
2. **`ContextMenuTheme` widget** (nearest ancestor in widget tree)
3. **`ThemeExtension`** on `ThemeData` (app-wide)
4. **Material `ColorScheme` defaults** (lowest priority, current behavior)

## Verification Steps

1. Run example app: `cd example && flutter run`
2. Open a context menu — verify it uses themed values
3. Switch light/dark mode — verify menu style updates
4. Open a menu with inline overrides — verify overrides win
5. Run `flutter analyze --fatal-warnings` — verify zero warnings
6. Run `dart format --output=none --set-exit-if-changed .` — verify formatting
