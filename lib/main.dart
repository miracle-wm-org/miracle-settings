import 'package:flutter/material.dart';
import 'package:miracle_wm_settings/applications/startup_apps_editor.dart';
import 'package:miracle_wm_settings/border/border_editor.dart';
import 'keybinds_editor/keybindings_editor.dart';
import 'general/general_settings.dart';
import 'animation/animation_editor.dart';
import 'workspace/workspace_editor.dart';
import 'ffi/miracle_config.dart';

void main() {
  final config = MiracleConfig.loadFromPath(
    "/home/matthew/.config/miracle-wm.yaml",
  );
  runApp(SettingsApp(config: config!));
}

class SettingsApp extends StatelessWidget {
  const SettingsApp({required this.config, super.key});

  final MiracleConfigData config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miracle WM Settings',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      ),
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
          onPressed: () {},
          tooltip: 'Save',
          child: const Icon(Icons.save),
        ));
  }
}
