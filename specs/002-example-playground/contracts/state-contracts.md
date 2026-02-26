# State Contracts: Example Playground

**Feature**: 002-example-playground
**Date**: 2026-02-26

This is a client-side Flutter app with no API endpoints. Contracts define the state mutation interface.

## PlaygroundState Public Interface

### Entry Management

| Method | Params | Effect |
|--------|--------|--------|
| `addEntry` | `EntryType type, [String? parentId]` | Adds new entry at end of list (or as child of parentId for submenus) |
| `removeEntry` | `String id` | Removes entry by id (recursively searches children) |
| `reorderEntry` | `String id, int newIndex, [String? newParentId]` | Moves entry to new position |
| `updateEntry` | `String id, EntryNode updated` | Replaces entry properties |

### Menu Properties

| Method | Params | Effect |
|--------|--------|--------|
| `setClipBehavior` | `Clip value` | Updates clipBehavior |
| `setRespectPadding` | `bool value` | Updates respectPadding |

### Style Layers

| Method | Params | Effect |
|--------|--------|--------|
| `updateInlineStyle` | `InlineStyleState style` | Replaces inline style state |
| `setInheritedThemeEnabled` | `bool value` | Toggles inherited theme |
| `updateInheritedThemeStyle` | `InlineStyleState style` | Replaces inherited theme style |
| `setThemeExtensionEnabled` | `bool value` | Toggles theme extension |
| `updateThemeExtensionStyle` | `InlineStyleState style` | Replaces theme extension style |

### App Settings

| Method | Params | Effect |
|--------|--------|--------|
| `setThemeMode` | `ThemeMode mode` | Switches light/dark |

### Read-Only Builders

| Getter | Returns | Description |
|--------|---------|-------------|
| `buildContextMenu()` | `ContextMenu<String>` | Full menu from current state |
| `buildInlineStyle()` | `ContextMenuStyle?` | Inline style (null if empty) |
| `buildInheritedStyle()` | `ContextMenuStyle?` | Inherited style (null if disabled) |
| `buildThemeExtensionStyle()` | `ContextMenuStyle?` | Extension style (null if disabled) |

## EntryNode Conversion Contract

`EntryNode.toEntry()` conversion rules:

| EntryType | Output | Mapping |
|-----------|--------|---------|
| `item` (isSubmenu=false) | `MenuItem<String>` | label→Text(label), icon→Icon(icon), shortcut→SingleActivator, enabled, textColor, value, trailing→trailingType/trailingText |
| `item` (isSubmenu=true) | `MenuItem<String>.submenu` | Same as above + items→children.map(toEntry) |
| `header` | `MenuHeader` | text→label, disableUppercase |
| `divider` | `MenuDivider` | height, thickness, indent, endIndent, color |
