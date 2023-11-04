# Flutter Context Menu

The package provides a flexible and customizable solution for creating and displaying context menus in Flutter applications. It allows you to easily add context menus to your UI, providing users with a convenient way to access additional options and actions specific to the selected item or area.

![preview](preview.gif "preview")

## Features

- **`ContextMenu` Widget**: The package includes a highly customizable context menu widget that can be easily integrated into your Flutter application. It provides a seamless and intuitive user experience, enhancing the usability of your app.

- **Hierarchical Structure**: The context menu supports a hierarchical structure with submenu functionality. This enables you to create nested menus, providing a clear and organized representation of options and suboptions.

- **Customization Options**: Customize the appearance and behavior of the context menu to match your app's design and requirements. Modify the style, positioning, animation, and interaction of the menu to create a cohesive user interface.

- **Selection Handling**: The package includes built-in selection handling for context menu items. It allows you to define callback functions for individual menu items, enabling you to execute specific actions or logic when an item is selected.

## Getting Started

To get started, install the package using the following command:
```bash
flutter pub add flutter_context_menu
```

or add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
    flutter_context_menu: ^0.1.2
```

## Usage

To use the package in your project, simply add the following import statement to your app's `main.dart` file:
```dart
import 'package:flutter_context_menu/flutter_context_menu.dart';
```
then, initialize a `ContextMenu`:
```dart

final items = <ContextMenuEntry>[
  DefaultContextMenuItem(
    label: 'Copy',
    icon: Icons.copy,
    onSelected: () {
      // implement copy
    },
  ),
  DefaultContextMenuItem(
    label: 'Paste',
    icon: Icons.paste,
    onSelected: () {
      // implement paste
    },
  ),
  DefaultContextMenuItem.submenu(
    label: 'Edit',
    icon: Icons.edit,
    items: [
      DefaultContextMenuItem(
        label: 'Undo',
        value: "Undo",
        icon: Icons.undo,
        onSelected: () {
          // implement undo
        },
      ),
      DefaultContextMenuItem(
        label: 'Redo',
        value: 'Redo',
        icon: Icons.redo,
        onSelected: () {
          // implement redo
        },
      ),
    ],
  ),
];

final myContextMenu = ContextMenu(
  items: items,
  position: const Offset(300, 300),
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
);
```

finally, show the context menu:
```dart
showContextMenu(context, contextMenu: myContextMenu);
// or 
myContextMenu.show(context);

// or get the selected item's value
final selectedValue = await myContextMenu.show(context);
print(selectedValue);
```

## Feedback and Contributions

We welcome feedback, bug reports, and contributions from the Flutter community. Help us improve the package by providing suggestions, reporting issues, or submitting pull requests on [GitHub](https://github.com/salah-rashad/flutter_context_menu).
