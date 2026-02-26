import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'screens/playground_screen.dart';
import 'state/playground_state.dart';

/// Root app widget that configures ShadcnApp with theme management.
///
/// Reads [PlaygroundState.appSettings.themeMode] and passes it to [ShadcnApp]
/// to support light/dark mode switching.
class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    final playgroundState = context.watch<PlaygroundState>();
    final themeMode = playgroundState.appSettings.themeMode;

    return ShadcnApp(
      title: 'Context Menu Playground',
      debugShowCheckedModeBanner: false,
      theme: const ThemeData(
        colorScheme: ColorSchemes.lightSlate,
      ),
      darkTheme: const ThemeData(
        colorScheme: ColorSchemes.darkSlate,
      ),
      themeMode: themeMode,
      home: const PlaygroundScreen(),
    );
  }
}
