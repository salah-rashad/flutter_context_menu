import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Predefined list of common Material icons for the icon picker.
/// These remain as Material Icons since they're the selectable options
/// that will be used in the embedded context menu.
const _kCommonIcons = <IconData>[
  Icons.add,
  Icons.add_circle,
  Icons.add_circle_outline,
  Icons.arrow_back,
  Icons.arrow_downward,
  Icons.arrow_forward,
  Icons.arrow_upward,
  Icons.attach_file,
  Icons.block,
  Icons.book,
  Icons.bookmark,
  Icons.bookmark_border,
  Icons.build,
  Icons.calendar_today,
  Icons.camera_alt,
  Icons.cancel,
  Icons.check,
  Icons.check_circle,
  Icons.check_circle_outline,
  Icons.clear,
  Icons.close,
  Icons.cloud,
  Icons.content_copy,
  Icons.content_cut,
  Icons.content_paste,
  Icons.delete,
  Icons.description,
  Icons.done,
  Icons.done_all,
  Icons.download,
  Icons.edit,
  Icons.error,
  Icons.error_outline,
  Icons.exit_to_app,
  Icons.favorite,
  Icons.favorite_border,
  Icons.file_copy,
  Icons.filter_list,
  Icons.folder,
  Icons.folder_open,
  Icons.help,
  Icons.help_outline,
  Icons.history,
  Icons.home,
  Icons.image,
  Icons.info,
  Icons.info_outline,
  Icons.insert_drive_file,
  Icons.keyboard_arrow_down,
  Icons.keyboard_arrow_left,
  Icons.keyboard_arrow_right,
  Icons.keyboard_arrow_up,
  Icons.language,
  Icons.link,
  Icons.list,
  Icons.lock,
  Icons.lock_open,
  Icons.mail,
  Icons.menu,
  Icons.more_horiz,
  Icons.more_vert,
  Icons.notifications,
  Icons.open_in_new,
  Icons.person,
  Icons.phone,
  Icons.photo_camera,
  Icons.print,
  Icons.refresh,
  Icons.remove,
  Icons.remove_circle,
  Icons.remove_circle_outline,
  Icons.save,
  Icons.search,
  Icons.send,
  Icons.settings,
  Icons.share,
  Icons.shopping_cart,
  Icons.star,
  Icons.star_border,
  Icons.text_fields,
  Icons.thumb_down,
  Icons.thumb_up,
  Icons.undo,
  Icons.upload,
  Icons.visibility,
  Icons.visibility_off,
  Icons.warning,
  Icons.warning_amber,
  Icons.zoom_in,
  Icons.zoom_out,
];

/// Icon picker button using shadcn_flutter components.
///
/// Displays a button that opens a dialog with a grid of common Material icons.
/// Returns `null` when "No icon" is selected.
class IconPicker extends StatelessWidget {
  /// Currently selected icon.
  final IconData? value;

  /// Called when the user selects an icon.
  final ValueChanged<IconData?>? onChanged;

  /// Label text displayed above the picker.
  final String label;

  /// Whether to show the "No icon" option.
  final bool showNoIconOption;

  const IconPicker({
    super.key,
    this.value,
    this.onChanged,
    this.label = 'Icon',
    this.showNoIconOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label).xSmall().semiBold(),
        const SizedBox(height: 4),
        OutlineButton(
          onPressed: () => _showIconPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(value ?? Icons.image_not_supported_outlined),
              const SizedBox(width: 8),
              Text(value != null ? _getIconName(value!) : 'No icon'),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronDown), // Chrome icon - Lucide
            ],
          ),
        ),
      ],
    );
  }

  void _showIconPicker(BuildContext context) {
    showDropdown(
      context: context,
      alignment: Alignment.topLeft,
      anchorAlignment: Alignment.bottomLeft,
      builder: (context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 280,
            maxWidth: 320,
            maxHeight: 400,
          ),
          child: SurfaceCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Text('Select Icon').semiBold(),
                      const Spacer(),
                      GhostButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        density: ButtonDensity.icon,
                        child:
                            const Icon(LucideIcons.x), // Chrome icon - Lucide
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // No icon option
                if (showNoIconOption)
                  GhostButton(
                    onPressed: () {
                      onChanged?.call(null);
                      Navigator.of(context).pop();
                    },
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Icon(Icons.image_not_supported_outlined),
                        const SizedBox(width: 8),
                        const Text('No icon'),
                        const Spacer(),
                        if (value == null)
                          const Icon(LucideIcons.check,
                              size: 16), // Chrome icon - Lucide
                      ],
                    ),
                  ),
                // Icon grid
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 48,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: _kCommonIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _kCommonIcons[index];
                      final isSelected = value == icon;

                      return Tooltip(
                        tooltip: (context) => TooltipContainer(
                          child: Text(_getIconName(icon)),
                        ),
                        child: isSelected
                            ? PrimaryButton(
                                onPressed: () {
                                  onChanged?.call(icon);
                                  Navigator.of(context).pop();
                                },
                                density: ButtonDensity.icon,
                                child: Icon(icon),
                              )
                            : GhostButton(
                                onPressed: () {
                                  onChanged?.call(icon);
                                  Navigator.of(context).pop();
                                },
                                density: ButtonDensity.icon,
                                child: Icon(icon),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Gets a human-readable name for an icon.
  String _getIconName(IconData icon) {
    // Map common icons to friendly names
    final iconNames = <IconData, String>{
      Icons.add: 'Add',
      Icons.add_circle: 'Add Circle',
      Icons.add_circle_outline: 'Add Circle Outline',
      Icons.arrow_back: 'Arrow Back',
      Icons.arrow_downward: 'Arrow Down',
      Icons.arrow_forward: 'Arrow Forward',
      Icons.arrow_upward: 'Arrow Up',
      Icons.attach_file: 'Attach File',
      Icons.block: 'Block',
      Icons.book: 'Book',
      Icons.bookmark: 'Bookmark',
      Icons.bookmark_border: 'Bookmark Border',
      Icons.build: 'Build',
      Icons.calendar_today: 'Calendar',
      Icons.camera_alt: 'Camera',
      Icons.cancel: 'Cancel',
      Icons.check: 'Check',
      Icons.check_circle: 'Check Circle',
      Icons.check_circle_outline: 'Check Circle Outline',
      Icons.clear: 'Clear',
      Icons.close: 'Close',
      Icons.cloud: 'Cloud',
      Icons.content_copy: 'Copy',
      Icons.content_cut: 'Cut',
      Icons.content_paste: 'Paste',
      Icons.delete: 'Delete',
      Icons.description: 'Description',
      Icons.done: 'Done',
      Icons.done_all: 'Done All',
      Icons.download: 'Download',
      Icons.edit: 'Edit',
      Icons.error: 'Error',
      Icons.error_outline: 'Error Outline',
      Icons.exit_to_app: 'Exit',
      Icons.favorite: 'Favorite',
      Icons.favorite_border: 'Favorite Border',
      Icons.file_copy: 'File Copy',
      Icons.filter_list: 'Filter',
      Icons.folder: 'Folder',
      Icons.folder_open: 'Folder Open',
      Icons.help: 'Help',
      Icons.help_outline: 'Help Outline',
      Icons.history: 'History',
      Icons.home: 'Home',
      Icons.image: 'Image',
      Icons.info: 'Info',
      Icons.info_outline: 'Info Outline',
      Icons.insert_drive_file: 'File',
      Icons.keyboard_arrow_down: 'Arrow Down',
      Icons.keyboard_arrow_left: 'Arrow Left',
      Icons.keyboard_arrow_right: 'Arrow Right',
      Icons.keyboard_arrow_up: 'Arrow Up',
      Icons.language: 'Language',
      Icons.link: 'Link',
      Icons.list: 'List',
      Icons.lock: 'Lock',
      Icons.lock_open: 'Lock Open',
      Icons.mail: 'Mail',
      Icons.menu: 'Menu',
      Icons.more_horiz: 'More Horizontal',
      Icons.more_vert: 'More Vertical',
      Icons.notifications: 'Notifications',
      Icons.open_in_new: 'Open in New',
      Icons.person: 'Person',
      Icons.phone: 'Phone',
      Icons.photo_camera: 'Photo Camera',
      Icons.print: 'Print',
      Icons.refresh: 'Refresh',
      Icons.remove: 'Remove',
      Icons.remove_circle: 'Remove Circle',
      Icons.remove_circle_outline: 'Remove Circle Outline',
      Icons.save: 'Save',
      Icons.search: 'Search',
      Icons.send: 'Send',
      Icons.settings: 'Settings',
      Icons.share: 'Share',
      Icons.shopping_cart: 'Shopping Cart',
      Icons.star: 'Star',
      Icons.star_border: 'Star Border',
      Icons.text_fields: 'Text Fields',
      Icons.thumb_down: 'Thumb Down',
      Icons.thumb_up: 'Thumb Up',
      Icons.undo: 'Undo',
      Icons.upload: 'Upload',
      Icons.visibility: 'Visibility',
      Icons.visibility_off: 'Visibility Off',
      Icons.warning: 'Warning',
      Icons.warning_amber: 'Warning Amber',
      Icons.zoom_in: 'Zoom In',
      Icons.zoom_out: 'Zoom Out',
    };

    return iconNames[icon] ?? icon.codePoint.toString();
  }
}
