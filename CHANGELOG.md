## v0.4.2

### Fixed

- **Type Erasure**: Resolved generic type erasure across context menu item handling and preserved
  generic type parameter in `MenuEntryWidget` state (Fixes #50, #51)

## v0.4.1

### Fixed

- **Hover Behavior**: Fixed hover state management in menu items to prevent items from remaining
  highlighted after mouse exit (Fixes #45)
- **Submenu Interaction**: Disabled submenus no longer open on hover when they are disabled (Fixes
  #44)

### Improved

- **Code Organization**:
    - Moved `BuildContextExtensions` to dedicated `build_context_ext.dart`
    - Moved `SingleActivatorExtensions` to `single_activator_ext.dart`
    - Improved overall code modularity and maintainability

### Refactoring

- Reordered `items` parameter in `MenuItem.submenu` constructor for better code organization
- Updated all relevant imports to match the new file structure

## v0.4.0

### **Breaking Changes**

* `MenuItem.label` changed from `String` to `Widget`.
* `MenuItem.icon` changed from `IconData?` to `Widget?`.
* `MenuItem.color` renamed to `MenuItem.textColor`.
* `ContextMenuRegion.enableGestures` renamed to `enableDefaultGestures`.
* `ContextMenuRegionBuilder`: the `showMenu` callback changed from `void Function()` to
  `void Function(Offset position)`.
* `ContextMenuItem.onSelected` changed from `VoidCallback?` to `ValueChanged<T?>?` — the callback
  now receives the selected value.
* `ContextMenuItem.items` changed from `List<ContextMenuEntry>?` to `List<ContextMenuEntry<T>>?`.
* `ContextMenuState` is now generic (`ContextMenuState<T>`). Custom `ContextMenuEntry` subclasses
  that reference `ContextMenuState` directly must add the type parameter.
* `ContextMenuRegion.onItemSelected` changed from `ValueChanged<T>?` to `ValueChanged<T?>?`.

### **Added**

* Support for **keyboard shortcuts** (`shortcut`) and **trailing widgets** (`trailing`) in
  `MenuItem`. (closes #33)
* `SingleActivatorExtensions` for human-readable shortcut strings (e.g., `"Ctrl+O"`).
* `onItemSelected` callback on `ContextMenuRegion` and `showContextMenu` for immediate selection
  handling without awaiting the route result.
* `kMenuItemHeight` and `kMenuItemIconSize` constants for consistent `MenuItem` layout.
* `mediaQuery` extension on `BuildContext` to simplify `MediaQuery` access.

### **Changed**

* **Full generics upgrade**: `ContextMenu<T>`, `ContextMenuItem<T>`, `ContextMenuEntry<T>`, and
  `ContextMenuState<T>` are now strongly typed throughout.
* Updated default `spawnAnchor` for submenus to improve positioning.
* `debugLabel` now uses `describeIdentity` for consistent element identification, and `MenuItem`
  includes its label in the output.
* Extracted `ContextMenuWidgetView` for cleaner separation of concerns.
* Updated example project to showcase new features.

### **Fixed**

* `showContextMenu` now uses the **root navigator** by default, ensuring the menu displays above
  nested navigators and preventing multiple instances. (Fixes #21)

### **Removed**

* Removed unused internal helpers: `hasSameFocusNodeId`, `getScreenRect`, and `parentMenuKey`.

## 0.3.0

### Added / Changed

- **feat**: A `requestFocus` parameter has been added to `MenuRouteOptions` and is utilized in the
  `showMenu` helper function.
- Updated `ContextMenuWidget`, `MenuHeader`, and `MenuItem` to use `Color.withValues()`.
- Minor improvements compatible with Flutter 3.27+.

### Breaking Changes

- Requires Flutter **3.27+** and Dart **3.6+**.
- Pubspec environment: `sdk: ^3.6.0`
- Not compatible with older Flutter versions (<3.27). Use `0.2.6` instead.

### Notes

- This release introduces a new API and may require changes in dependent code.

## 0.2.6

### Fixed

* Replaced `Color.withValues()` with `color.withOpacity()` for compatibility with Flutter 3.0–3.26.
* Ensured `ContextMenuWidget`, `MenuHeader`, and `MenuItem` work on older Flutter versions.

### Notes

* This release is intended for users on Flutter versions **below 3.27**.
* No new features introduced; only compatibility fixes.
* Pubspec environment: `sdk: '>=3.0.0 <3.6.0'`

## 0.2.5

* **Refactor**: Improve/Fix submenu positioning logic.
* **FEAT**: Handle long menus properly with scrolling and add example for long menu.
* **FEAT**: Allow customization of context menu max height.

## 0.2.4

* **FIX**: enable/disable context menu based on web platform.

## 0.2.3

* Fix context menu is not showing in web (closes #7).
* Add keyboard shortcuts to navigate through the context menu items using the arrow keys (closes
  #12).
* Fix bug when using `setPathUrlStrategy()` in web (closes #17).

## 0.2.2

* Update `README.md`.
* Update default shortcuts.
* Add generic types to base classes and widgets (closes #3).
* Updated `ContextMenuRegion` for simplified gesture handling. (closes #4)
* Updated `ContextMenuRegion` to be more customizable with builder. (closes #6)
* Fix menu to not auto focus on first item. (closes #11).
* Fix focus bugs.

## 0.2.1

* Add `color` variable to the context menu item, allowing the item text and icon colors to be
  customized.
* Add `enabled` variable to the context menu item, allowing the item to be disabled if needed.
* Add `maybeOf(BuildContext)` to the context menu state.
* Move `calculateSubmenuPosition` to the utils file (`lib/src/core/utils.dart`).
* Some UI changes in the example project.

## 0.2.0

* Removed `provider` and `equatable` dependencies as they are no longer needed.
* Updated the package's dependencies to the latest versions.
* Removed unnecessary platform specific folders.
* The package is now fully dependent on InheritedWidget for state management.
* Replaced the old `Overlay` widget with the new `OverlayPortal` widget.
* Globally applied focus node highlighting and keyboard shortcuts for menu items.
* Added `shortcuts` property in the `ContextMenu` class for custom context menu shortcuts.

## 0.1.3

* updated example project.
* added `ContextMenuRegion` widget to show a context menu when a user right-clicks or long-presses
  on a widget.
* improvements and fixes.
* updated `README.md`.

## 0.1.2

* added example project.
* added a preview gif to "README" file.
* added `DefaultContextMenuDivider` in components.
* added `DefaultContextMenuItem` in components.
* added `DefaultContextMenuTextHeader` in components.
* improvements and fixes.