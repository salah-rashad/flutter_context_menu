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