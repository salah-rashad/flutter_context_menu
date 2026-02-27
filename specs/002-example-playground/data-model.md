# Data Model: Example Playground

**Feature**: 002-example-playground
**Date**: 2026-02-26

## Entities

### PlaygroundState (ChangeNotifier)

Central state object exposed via `ChangeNotifierProvider` at the app root.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| entries | `List<EntryNode>` | Default sample entries | Tree of menu entry configurations |
| menuProperties | `MenuPropertiesState` | Defaults | ContextMenu-level properties |
| inlineStyle | `InlineStyleState` | Empty (all null) | Direct ContextMenuStyle overrides |
| inheritedTheme | `InheritedThemeState` | Disabled, empty | ContextMenuTheme wrapper config |
| themeExtension | `ThemeExtensionState` | Disabled, empty | ThemeData.extensions config |
| appSettings | `AppSettingsState` | Light mode | App-level settings |
| lastSelectedValue | `String?` | null | Last selected item value for feedback display |

**Methods**:
- `ContextMenu<String> buildContextMenu()` — Constructs a `ContextMenu` from current entries + menuProperties + inlineStyle
- `ContextMenuStyle? buildInlineStyle()` — Builds the inline `ContextMenuStyle` from inlineStyle (null if all empty)
- `ContextMenuStyle? buildInheritedStyle()` — Builds the inherited `ContextMenuStyle` (null if disabled)
- `ContextMenuStyle? buildThemeExtensionStyle()` — Builds the extension `ContextMenuStyle` (null if disabled)

---

### EntryNode

Represents a single menu entry in the tree editor. Recursive for submenus.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| id | `String` | UUID | Unique identifier for tree operations |
| type | `EntryType` | `item` | One of: `item`, `header`, `divider` |
| label | `String` | "New Item" | Display text (items and headers) |
| icon | `IconData?` | null | Material icon (items only) — selected from a predefined Material Icons list; Material icons are used here as the playground simulates a real consumer app |
| shortcutLabel | `String?` | null | Shortcut display text, e.g., "Ctrl+C" (items only) |
| enabled | `bool` | true | Whether the item is selectable (items only) |
| textColor | `Color?` | null | Inline text color override (items only) |
| value | `String?` | null | Associated value returned on selection (items only) |
| trailingType | `TrailingType` | `none` | Trailing widget type: none, chevron, or custom text (items only) |
| trailingText | `String?` | null | Custom trailing text when trailingType is `customText` (items only) |
| isSubmenu | `bool` | false | Whether this item has children (items only) |
| children | `List<EntryNode>` | [] | Child entries for submenus |
| disableUppercase | `bool` | false | Disable auto-uppercase (headers only) |
| dividerHeight | `double?` | null | Custom height (dividers only) |
| dividerThickness | `double?` | null | Custom thickness (dividers only) |
| dividerIndent | `double?` | null | Custom indent (dividers only) |
| dividerEndIndent | `double?` | null | Custom end indent (dividers only) |
| dividerColor | `Color?` | null | Custom color (dividers only) |

**Methods**:
- `ContextMenuEntry<String> toEntry()` — Converts to the package's entry type (MenuItem, MenuHeader, or MenuDivider)

---

### EntryType (enum)

```
item     — MenuItem (selectable, with icon/shortcut/submenu)
header   — MenuHeader (non-interactive label)
divider  — MenuDivider (visual separator)
```

---

### TrailingType (enum)

```
none        — No trailing widget
chevron     — Chevron/arrow icon (Icon(Icons.chevron_right))
customText  — Custom text widget (uses trailingText field)
```

---

### MenuPropertiesState

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| clipBehavior | `Clip` | `Clip.antiAlias` | Menu clip behavior |
| respectPadding | `bool` | true | Whether to respect padding for submenus |

---

### InlineStyleState

All fields nullable. When non-null, they are passed to `ContextMenuStyle` on the `ContextMenu` instance.

| Field | Type | Description |
|-------|------|-------------|
| surfaceColor | `Color?` | Menu background |
| shadowColor | `Color?` | Shadow color |
| shadowOffset | `Offset?` | Shadow offset |
| shadowBlurRadius | `double?` | Shadow blur |
| shadowSpreadRadius | `double?` | Shadow spread |
| borderRadius | `double?` | Corner radius (converted to `BorderRadius.circular`) |
| padding | `double?` | Inner padding (converted to `EdgeInsets.all`) |
| maxWidth | `double?` | Maximum menu width |
| maxHeight | `double?` | Maximum menu height |
| menuItemStyle | `MenuItemStyleState?` | Nested item style overrides |
| menuHeaderStyle | `MenuHeaderStyleState?` | Nested header style overrides |
| menuDividerStyle | `MenuDividerStyleState?` | Nested divider style overrides |

---

### MenuItemStyleState

All fields nullable. Maps to `MenuItemStyle` properties.

| Field | Type | Description |
|-------|------|-------------|
| backgroundColor | `Color?` | Normal background |
| focusedBackgroundColor | `Color?` | Hovered/focused background |
| textColor | `Color?` | Normal text color |
| focusedTextColor | `Color?` | Focused text color |
| disabledTextColor | `Color?` | Disabled text color |
| iconColor | `Color?` | Icon color |
| iconSize | `double?` | Icon size |
| shortcutTextColor | `Color?` | Shortcut text color |
| shortcutTextOpacity | `double?` | Shortcut text opacity |
| height | `double?` | Item height |
| borderRadius | `double?` | Item corner radius |

---

### MenuHeaderStyleState

All fields nullable. Maps to `MenuHeaderStyle` properties.

| Field | Type | Description |
|-------|------|-------------|
| textColor | `Color?` | Header text color |
| padding | `double?` | Header padding (converted to `EdgeInsets.all`) |

---

### MenuDividerStyleState

All fields nullable. Maps to `MenuDividerStyle` properties.

| Field | Type | Description |
|-------|------|-------------|
| color | `Color?` | Divider color |
| height | `double?` | Divider height |
| thickness | `double?` | Line thickness |
| indent | `double?` | Left indent |
| endIndent | `double?` | Right indent |

---

### InheritedThemeState

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| enabled | `bool` | false | Whether to wrap menu in `ContextMenuTheme` |
| style | `InlineStyleState` | Empty | Style values (same shape as InlineStyleState) |

---

### ThemeExtensionState

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| enabled | `bool` | false | Whether to add style to `ThemeData.extensions` |
| style | `InlineStyleState` | Empty | Style values (same shape as InlineStyleState) |

---

### AppSettingsState

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| themeMode | `ThemeMode` | `ThemeMode.light` | Current brightness mode |

## State Lifecycle

```
App Launch
  → PlaygroundState initialized with default sample entries + all defaults
  → Context menu rendered immediately from state

User Interaction
  → Tools panel widgets call mutators on PlaygroundState
  → PlaygroundState.notifyListeners()
  → Playground area rebuilds with updated ContextMenu

Item Selection
  → onItemSelected callback fires
  → PlaygroundState.lastSelectedValue updated
  → Feedback displayed (toast/snackbar)
  → Menu remains visible (no dismissal)

App Close
  → State discarded (no persistence)
```

## Default Sample Entries

On initial load, the playground provides a representative set of entries:

```
MenuHeader("File")
MenuItem(label: "New File", icon: Icons.add, shortcut: "Ctrl+N", value: "new_file")
MenuItem(label: "Open", icon: Icons.folder_open, shortcut: "Ctrl+O", value: "open")
MenuItem(label: "Save", icon: Icons.save, shortcut: "Ctrl+S", value: "save")
MenuDivider()
MenuItem.submenu(label: "Recent Files", icon: Icons.history, children: [
  MenuItem(label: "document.txt", value: "recent_1")
  MenuItem(label: "image.png", value: "recent_2")
  MenuItem(label: "data.csv", value: "recent_3")
])
MenuDivider()
MenuItem(label: "Exit", icon: Icons.close, value: "exit", enabled: false)
```
