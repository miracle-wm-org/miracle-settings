import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:miracle_settings/applications/startup_apps_editor.dart';
import 'package:miracle_settings/config.dart';
import 'keybinds_editor/keybindings_editor.dart';
import 'general/general_settings.dart';
import 'animation/animation_editor.dart';
import 'workspace/workspace_editor.dart';
import 'ffi/miracle_config.dart';

const draculaBackground = Color(0xFF282A36);
const draculaCurrentLine = Color(0xFF44475A);
const draculaForeground = Color(0xFFF8F8F2);
const draculaComment = Color(0xFF6272A4);
const draculaCyan = Color(0xFF8BE9FD);
const draculaGreen = Color(0xFF50FA7B);
const draculaOrange = Color(0xFFFFB86C);
const draculaPink = Color(0xFFFF79C6);
const draculaPurple = Color(0xFFBD93F9);
const draculaRed = Color(0xFFFF5555);
const draculaYellow = Color(0xFFF1FA8C);

final ThemeData draculaLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: draculaPurple,
  colorScheme: ColorScheme.light(
    primary: draculaPurple,
    secondary: draculaCyan,
    surface: Colors.grey.shade100,
    background: Colors.white,
    error: draculaRed,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: draculaComment),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade100,
    foregroundColor: Colors.black,
    elevation: 1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: draculaPurple,
      foregroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF0F0F0),
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: draculaComment),
  ),
);

final ThemeData draculaDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: draculaBackground,
  primaryColor: draculaPurple,
  colorScheme: ColorScheme.dark(
    primary: draculaPurple,
    secondary: draculaCyan,
    surface: draculaCurrentLine,
    background: draculaBackground,
    error: draculaRed,
    onPrimary: draculaBackground,
    onSecondary: draculaBackground,
    onSurface: draculaForeground,
    onBackground: draculaForeground,
    onError: draculaBackground,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        color: draculaForeground, fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        color: draculaForeground, fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(
        color: draculaForeground, fontSize: 16, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: draculaForeground, fontSize: 14),
    bodyMedium: TextStyle(color: draculaForeground, fontSize: 14),
    bodySmall: TextStyle(color: draculaComment, fontSize: 14),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: draculaCurrentLine,
    foregroundColor: draculaForeground,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: draculaGreen,
      foregroundColor: draculaBackground,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: draculaCurrentLine,
    border: OutlineInputBorder(),
    hintStyle: TextStyle(color: draculaComment),
  ),
);

void main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final log = Logger('main');
  final parser = ConfigParser();
  final miracleConfigPath = await parser.getConfigFilePath();
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
      darkTheme: draculaDarkTheme,
      theme: draculaLightTheme,
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
  bool _hasUnsavedChanges = false;

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
      icon: Icon(Icons.animation),
      label: Text('Animations'),
    ),
  ];

  static List<Widget Function(SettingsHomePage home)> contentViews = [
    (SettingsHomePage home) => GeneralSettings(config: home.config),
    (SettingsHomePage home) => KeybindingsEditor(config: home.config),
    (SettingsHomePage home) => StartupAppsEditor(config: home.config),
    (SettingsHomePage home) => WorkspaceEditor(config: home.config),
    (SettingsHomePage home) => AnimationEditor(config: home.config),
  ];

  @override
  void initState() {
    super.initState();
    widget.config.addListener(_setUnsavedChanges);
  }

  @override
  void dispose() {
    widget.config.removeListener(_setUnsavedChanges);
    super.dispose();
  }

  void _setUnsavedChanges() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

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
        floatingActionButton: IgnorePointer(
            ignoring: !_hasUnsavedChanges,
            child: FloatingActionButton(
              backgroundColor: _hasUnsavedChanges
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
              foregroundColor: _hasUnsavedChanges
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimary.withOpacity(0.38),
              disabledElevation: 0,
              onPressed: () {
                if (!_hasUnsavedChanges) {
                  return;
                }

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

                setState(() {
                  _hasUnsavedChanges = false;
                });
              },
              tooltip: 'Save',
              child: const Icon(Icons.save),
            )));
  }
}
