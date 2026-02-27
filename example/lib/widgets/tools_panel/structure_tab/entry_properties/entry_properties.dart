import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../state/entry_node.dart';
import 'divider_fields.dart';
import 'header_fields.dart';
import 'item_fields.dart';
import 'properties_empty_state.dart';
import 'property_type_header.dart';

/// Property editor panel for the currently selected [EntryNode].
///
/// Displays fields based on the entry type:
/// - **Item**: label, enabled, value, submenu toggle
/// - **Header**: label, disableUppercase
/// - **Divider**: height, thickness, indent, endIndent
class EntryProperties extends StatefulWidget {
  final EntryNode? entry;
  final ValueChanged<EntryNode>? onUpdate;

  const EntryProperties({
    super.key,
    this.entry,
    this.onUpdate,
  });

  @override
  State<EntryProperties> createState() => _EntryPropertiesState();
}

class _EntryPropertiesState extends State<EntryProperties> {
  final Map<String, TextEditingController> _controllers = {};
  String? _currentEntryId;

  @override
  void didUpdateWidget(EntryProperties oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entry?.id != oldWidget.entry?.id) {
      _currentEntryId = widget.entry?.id;
      _syncControllersWithEntry();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  void _syncControllersWithEntry() {
    final entry = widget.entry;
    if (entry == null) return;
    _ctrl('label').text = entry.label;
    _ctrl('value').text = entry.value ?? '';
    _ctrl('dividerHeight').text =
        entry.dividerHeight?.toStringAsFixed(1) ?? '';
    _ctrl('dividerThickness').text =
        entry.dividerThickness?.toStringAsFixed(1) ?? '';
    _ctrl('dividerIndent').text =
        entry.dividerIndent?.toStringAsFixed(1) ?? '';
    _ctrl('dividerEndIndent').text =
        entry.dividerEndIndent?.toStringAsFixed(1) ?? '';
  }

  TextEditingController _ctrl(String name) =>
      _controllers.putIfAbsent(name, TextEditingController.new);

  // ---------------------------------------------------------------------------
  // Update helpers
  // ---------------------------------------------------------------------------

  void _update(EntryNode Function(EntryNode e) fn) {
    if (widget.entry == null) return;
    widget.onUpdate?.call(fn(widget.entry!));
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (widget.entry == null) return const PropertiesEmptyState();

    if (_currentEntryId != widget.entry?.id) {
      _currentEntryId = widget.entry?.id;
      _syncControllersWithEntry();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyTypeHeader(entry: widget.entry!),
          const SizedBox(height: 12),
          _buildTypeFields(),
        ],
      ),
    );
  }

  Widget _buildTypeFields() {
    final entry = widget.entry!;
    return switch (entry.type) {
      EntryType.item => ItemFields(
          entry: entry,
          labelController: _ctrl('label'),
          valueController: _ctrl('value'),
          onLabelSubmit: (v) => _update((e) => e.copyWith(label: v)),
          onValueSubmit: (v) => _update((e) => e.copyWith(value: v)),
          onEnabledChanged: (v) => _update((e) => e.copyWith(enabled: v)),
          onIsSubmenuChanged: (v) => _update((e) => e.copyWith(isSubmenu: v)),
        ),
      EntryType.header => HeaderFields(
          entry: entry,
          labelController: _ctrl('label'),
          onLabelSubmit: (v) => _update((e) => e.copyWith(label: v)),
          onDisableUppercaseChanged: (v) =>
              _update((e) => e.copyWith(disableUppercase: v)),
        ),
      EntryType.divider => DividerFields(
          heightController: _ctrl('dividerHeight'),
          thicknessController: _ctrl('dividerThickness'),
          indentController: _ctrl('dividerIndent'),
          endIndentController: _ctrl('dividerEndIndent'),
          onHeightSubmit: (v) => _update((e) => e.copyWith(dividerHeight: v)),
          onThicknessSubmit: (v) =>
              _update((e) => e.copyWith(dividerThickness: v)),
          onIndentSubmit: (v) => _update((e) => e.copyWith(dividerIndent: v)),
          onEndIndentSubmit: (v) =>
              _update((e) => e.copyWith(dividerEndIndent: v)),
        ),
    };
  }
}
