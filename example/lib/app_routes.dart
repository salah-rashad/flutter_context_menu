import 'package:flutter/material.dart';

import 'data/models/example_model.dart';
import 'features/advanced/widgets/custom_items_example.dart';
import 'features/advanced/widgets/custom_style_example.dart';
import 'features/advanced/widgets/keyboard_shortcuts_example.dart';
import 'features/basic/widgets/menu_with_icons_example.dart';
import 'features/basic/widgets/simple_menu_example.dart';
import 'features/real_world/widgets/file_explorer_example.dart';
import 'screens/example_screen.dart';
import 'screens/home_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String basic = '/basic';
  static const String advanced = '/advanced';
  static const String realWorld = '/real-world';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case basic:
      case advanced:
      case realWorld:
        final example = settings.arguments as ExampleModel?;
        return MaterialPageRoute(
          builder: (_) => ExampleScreen(example: example!),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static List<ExampleModel> getExamples() {
    return [
      // Basic Examples
      const ExampleModel(
        id: 'basic_simple',
        title: 'Simple Menu',
        description: 'A basic context menu with default styling',
        route: basic,
        icon: Icons.menu,
        category: ExampleCategory.basic,
        exampleWidget: SimpleMenuExample(),
      ),
      const ExampleModel(
        id: 'basic_with_icons',
        title: 'Menu with Icons',
        description: 'Context menu with icons for each item',
        route: basic,
        icon: Icons.image,
        category: ExampleCategory.basic,
        exampleWidget: MenuWithIconsExample(),
      ),

      // Advanced Features
      const ExampleModel(
        id: 'advanced_custom_style',
        title: 'Custom Styling',
        description: 'Custom styling for context menus',
        route: advanced,
        icon: Icons.palette,
        category: ExampleCategory.advanced,
        exampleWidget: CustomStyleExample(),
      ),
      const ExampleModel(
        id: 'advanced_custom_items',
        title: 'Custom Menu Items',
        description: 'Create your own custom menu item types',
        route: advanced,
        icon: Icons.toggle_on,
        category: ExampleCategory.advanced,
        exampleWidget: CustomItemsExample(),
      ),
      const ExampleModel(
        id: 'advanced_keyboard_shortcuts',
        title: 'Keyboard Shortcuts',
        description: 'Menu items with keyboard shortcuts',
        route: advanced,
        icon: Icons.keyboard,
        category: ExampleCategory.advanced,
        exampleWidget: KeyboardShortcutsExample(),
      ),

      // Real-world Examples
      const ExampleModel(
        id: 'real_file_explorer',
        title: 'File Explorer',
        description: 'Context menu for a file explorer interface',
        route: realWorld,
        icon: Icons.folder,
        category: ExampleCategory.realWorld,
        exampleWidget: FileExplorerExample(),
      ),
    ];
  }
}
