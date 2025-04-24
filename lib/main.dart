import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:miracle_wm_settings/applications/startup_apps_editor.dart';
import 'package:miracle_wm_settings/border/border_editor.dart';
import 'keybinds_editor/keybindings_editor.dart';
import 'general/general_settings.dart';
import 'animation/animation_editor.dart';
import 'workspace/workspace_editor.dart';
import 'ffi/miracle_config.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

String findOrCreateConfigFile(String relativePath) {
  final env = Platform.environment;
  final home = env['HOME'];
  if (home == null) {
    throw Exception("HOME environment variable is not set.");
  }

  final xdgConfigHome = env['XDG_CONFIG_HOME'] ?? p.join(home, '.config');
  final fallbackConfigPath = p.join(xdgConfigHome, relativePath);

  // Check if file exists in any XDG path
  final pathsToCheck = <String>[
    p.join(xdgConfigHome, relativePath),
    if (xdgConfigHome != p.join(home, '.config'))
      p.join(home, '.config', relativePath),
    for (final dir in (env['XDG_CONFIG_DIRS'] ?? '/etc/xdg').split(':'))
      p.join(dir, relativePath),
  ];

  for (final path in pathsToCheck) {
    final file = File(path);
    if (file.existsSync()) {
      return file.path;
    }
  }

  // If not found, create the file in $XDG_CONFIG_HOME or fallback
  final fileToCreate = File(fallbackConfigPath);
  fileToCreate.parent.createSync(recursive: true);
  fileToCreate.createSync();
  return fileToCreate.path;
}

final ThemeData lightDraculaTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xFFF8F8F2),
  primaryColor: Color(0xFFBD93F9),
  canvasColor: Color(0xFFE6E6E6),
  cardColor: Color(0xFFE6E6E6),
  dividerColor: Color(0xFF6272A4),
  hintColor: Color(0xFF6272A4),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFE6E6E6),
    iconTheme: IconThemeData(color: Color(0xFF282A36)),
    titleTextStyle: TextStyle(color: Color(0xFF282A36), fontSize: 20),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF282A36)),
    bodyMedium: TextStyle(color: Color(0xFF282A36)),
    labelLarge: TextStyle(color: Color(0xFF6272A4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFBD93F9),
      foregroundColor: Color(0xFFF8F8F2),
    ),
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFFBD93F9),
    secondary: Color(0xFF8BE9FD),
    error: Color(0xFFFF5555),
    background: Color(0xFFF8F8F2),
    surface: Color(0xFFE6E6E6),
    onPrimary: Color(0xFFF8F8F2),
    onSecondary: Color(0xFF282A36),
    onError: Color(0xFFF8F8F2),
    onBackground: Color(0xFF282A36),
    onSurface: Color(0xFF282A36),
  ),
);

final ThemeData darkDraculaTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF282A36),
  primaryColor: Color(0xFFBD93F9), // Purple
  hintColor: Color(0xFF6272A4), // Comment
  canvasColor: Color(0xFF282A36),
  cardColor: Color(0xFF44475A),
  dividerColor: Color(0xFF6272A4),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFF8F8F2)), // Foreground
    bodyMedium: TextStyle(color: Color(0xFFF8F8F2)),
    labelLarge: TextStyle(color: Color(0xFFF1FA8C)), // Yellow
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF44475A),
    iconTheme: IconThemeData(color: Color(0xFFF8F8F2)),
    titleTextStyle: TextStyle(color: Color(0xFFF8F8F2), fontSize: 20),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFBD93F9),
    secondary: Color(0xFF8BE9FD), // Cyan
    error: Color(0xFFFF5555), // Red
    background: Color(0xFF282A36),
    surface: Color(0xFF44475A),
    onPrimary: Color(0xFF282A36),
    onSecondary: Color(0xFF282A36),
    onError: Color(0xFFF8F8F2),
    onBackground: Color(0xFFF8F8F2),
    onSurface: Color(0xFFF8F8F2),
  ),
);

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final log = Logger('main');
  final String miracleConfigPath = findOrCreateConfigFile('miracle-wm.yaml');
  log.info('Miracle WM config path: $miracleConfigPath');
  final config = MiracleConfig.loadFromPath(miracleConfigPath);
  if (config == null) {
    log.warning('Failed to load Miracle WM config from $miracleConfigPath');
  } else {
    log.info('Loaded Miracle WM config from $miracleConfigPath');
  }
  runApp(SettingsApp(config: config!));
}

class SettingsApp extends StatelessWidget {
  const SettingsApp({required this.config, super.key});

  final MiracleConfigData config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miracle WM Settings',
      darkTheme: darkDraculaTheme,
      theme: lightDraculaTheme,
      home: SettingsHomePage(config: config),
    );
  }
}

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({required this.config, super.key});

  final MiracleConfigData config;

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  int _selectedIndex = 0;

  static const List<NavigationRailDestination> destinations = [
    NavigationRailDestination(icon: Icon(Icons.tune), label: Text('General')),
    NavigationRailDestination(
      icon: Icon(Icons.keyboard),
      label: Text('Keybindings'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.apps),
      label: Text('Applications'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.space_dashboard),
      label: Text('Workspaces'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.border_all),
      label: Text('Borders'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.animation),
      label: Text('Animations'),
    ),
  ];

  static List<Widget Function(SettingsHomePage home)> contentViews = [
    (SettingsHomePage home) => GeneralSettings(config: home.config),
    (SettingsHomePage home) => KeybindingsEditor(config: home.config),
    (SettingsHomePage home) => StartupAppsEditor(config: home.config),
    (SettingsHomePage home) => WorkspaceEditor(config: home.config),
    (SettingsHomePage home) => BorderEditor(config: home.config),
    (SettingsHomePage home) => AnimationEditor(config: home.config),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: destinations,
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: contentViews[_selectedIndex](widget),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            final result = widget.config.saveToPath(widget.config.path);
            if (result.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Text('Saved the configuration'),
                  duration: Duration(seconds: 3), // Show for 3 seconds
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: Text('Failed to save the configuration'),
                  duration: Duration(seconds: 3), // Show for 3 seconds
                ),
              );
            }
          },
          tooltip: 'Save',
          child: const Icon(Icons.save),
        ));
  }
}
