import 'package:example/entries/custom_context_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../widgets/context_menu_region.dart';

part 'demo_page_2.dart';

Map<String, ContextMenu> _contextMenus() => {
      "Default (built-in)": ContextMenu(items: _defaultContextMenuItems),
      "Custom\n\nmax width: 200\npadding: 0": ContextMenu(
        items: _customContextMenuItems,
        maxWidth: 200,
        padding: EdgeInsets.zero,
      ),
      "Custom\n\nmax width: 150\npadding: horizontal(8)": ContextMenu(
        items: _customContextMenuItems,
        maxWidth: 150,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
      "Default\n\nposition (x: 50, y: 30)\npadding: 0": ContextMenu(
        items: _defaultContextMenuItems,
        padding: EdgeInsets.zero,
        position: const Offset(50, 30),
      )
    };

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Flutter Context Menu Demo"),
      ),
      // body: Row(
      //   children: [
      //     Expanded(
      //       child: ContextMenuRegion(
      //         color: context.colorScheme.inverseSurface,
      //         text: "ContextMenu",
      //         contextMenu: ContextMenu(items: items),
      //       ),
      //     ),
      //     Expanded(
      //       child: ContextMenuRegion(
      //         color: context.colorScheme.onBackground,
      //       ),
      //     ),
      //   ],
      // ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          final colorScheme = Theme.of(context).colorScheme;
          final color = index % 2 == 0
              ? colorScheme.inverseSurface
              : colorScheme.onBackground;

          final entry = _contextMenus().entries.toList()[index];
          return ContextMenuRegion(
            color: color,
            contextMenu: entry.value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  entry.key,
                  style: TextStyle(color: colorScheme.surface),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
