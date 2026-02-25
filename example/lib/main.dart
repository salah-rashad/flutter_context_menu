import 'package:example/pages/demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Context Menu Demo',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        // Define a global context menu style via ThemeExtension
        // All context menus will inherit this styling unless overridden
        extensions: [
          ContextMenuStyle(
            borderRadius: BorderRadius.circular(12.0),
            padding: const EdgeInsets.all(8.0),
            shadowColor: Colors.black.withValues(alpha: 0.5),
            shadowBlurRadius: 8.0,
            shadowOffset: const Offset(0, 4),
            // Customize menu item styles globally
            menuItemStyle: MenuItemStyle(
              height: 40.0,
              focusedBackgroundColor: Colors.blue.shade900,
              textColor: Colors.indigo.shade200,
              focusedTextColor: Colors.white,
              iconSize: 18.0,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
      home: const DemoPage(),
    );
  }
}
