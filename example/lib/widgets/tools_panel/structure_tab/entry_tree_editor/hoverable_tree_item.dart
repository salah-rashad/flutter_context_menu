import 'package:shadcn_flutter/shadcn_flutter.dart';

/// A hover-aware wrapper for TreeItemView that shows trailing on hover/selection.
class HoverableTreeItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<bool>? onExpand;
  final Widget child;
  final bool isSelected;

  const HoverableTreeItem({
    super.key,
    this.onPressed,
    this.leading,
    this.trailing,
    this.onExpand,
    required this.child,
    this.isSelected = false,
  });

  @override
  State<HoverableTreeItem> createState() => _HoverableTreeItemState();
}

class _HoverableTreeItemState extends State<HoverableTreeItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showTrailing = _isHovered || widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TreeItemView(
        onPressed: widget.onPressed,
        leading: widget.leading,
        trailing: widget.trailing != null
            ? AnimatedOpacity(
                opacity: showTrailing ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: widget.trailing!,
              )
            : null,
        onExpand: widget.onExpand,
        child: widget.child,
      ),
    );
  }
}
