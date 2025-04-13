import 'package:flutter/material.dart';
import 'keybinds_editor/keybindings_editor.dart';
import 'general/general_settings.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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
      label: Text('Layouts'),
    ),
  ];

  static List<Widget Function(SettingsHomePage home)> contentViews = [
    (SettingsHomePage home) => GeneralSettings(config: home.config),
    (SettingsHomePage home) => KeybindingsEditor(config: home.config),
    (SettingsHomePage home) => GeneralSettings(config: home.config),
    (SettingsHomePage home) => Center(child: Text('Workspace Configuration')),
    (SettingsHomePage home) => Center(child: Text('Layout Preferences')),
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
    );
  }
}
