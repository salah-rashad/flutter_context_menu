## 0.2.1

* Add `color` variable to the context menu item, allowing the item text and icon colors to be customized.
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
* added `ContextMenuRegion` widget to show a context menu when a user right-clicks or long-presses on a widget.
* improvements and fixes.
* updated `README.md`.

## 0.1.2

* added example project.
* added a preview gif to "README" file.
* added `DefaultContextMenuDivider` in components.
* added `DefaultContextMenuItem` in components.
* added `DefaultContextMenuTextHeader` in components.
* improvements and fixes.