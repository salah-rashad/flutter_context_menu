import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Collapsible section header widget using shadcn_flutter components.
///
/// Displays a title with an expand/collapse toggle.
class SectionHeader extends StatefulWidget {
  /// The section title.
  final String title;

  /// Whether the section is initially expanded.
  final bool initiallyExpanded;

  /// The content to show/hide when expanded/collapsed.
  final Widget child;

  /// Optional trailing widget (e.g., action buttons).
  final Widget? trailing;

  /// Called when the expanded state changes.
  final ValueChanged<bool>? onExpansionChanged;

  const SectionHeader({
    super.key,
    required this.title,
    this.initiallyExpanded = true,
    required this.child,
    this.trailing,
    this.onExpansionChanged,
  });

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        GhostButton(
          onPressed: _toggleExpansion,
          child: Row(
            children: [
              // Expand/collapse icon
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: _isExpanded ? 0.25 : 0,
                child: const Icon(LucideIcons.chevronRight).small().muted(),
              ),
              const SizedBox(width: 8),
              // Title
              Expanded(
                child: Text(widget.title).small().semiBold(),
              ),
              // Optional trailing widget
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
        // Content with animation
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 26,
                      bottom: 8,
                    ),
                    child: widget.child,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

/// A simpler non-collapsible section header using shadcn_flutter.
///
/// Just displays a title with optional trailing widget.
/// Used when collapsibility is not needed.
class SimpleSectionHeader extends StatelessWidget {
  /// The section title.
  final String title;

  /// Optional trailing widget.
  final Widget? trailing;

  const SimpleSectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title).small().semiBold(),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
